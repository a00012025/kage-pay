// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/contract_util.dart';
import 'package:app/features/common/contract/entry_point_contract.dart';
import 'package:app/features/common/contract/simple_account_factory_contract.dart';
import 'package:app/features/payment/application/payment_exception.dart';
import 'package:app/features/payment/domain/chain.dart';
import 'package:app/features/payment/domain/user_operation.dart';
import 'package:app/features/payment/domain/utxo_address.dart';
import 'package:app/utils/stealth_private_key.dart';
import 'package:eth_sig_util/eth_sig_util.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class PaymentService {
  final EntryPointContract entryPointContract;
  final SimpleAccountFactoryContract simpleAccountFactoryContract;
  PaymentService()
      : entryPointContract = EntryPointContract.create(),
        simpleAccountFactoryContract = SimpleAccountFactoryContract.create();

  static Web3Client getWeb3Client() {
    var httpClient = http.Client();
    return Web3Client('https://eth-sepolia.public.blastapi.io', httpClient);
  }

  Future<List<UtxoAddress>> getAddressesToSend({
    required List<UtxoAddress> addresses,
    required BigInt amountToSend,
  }) async {
    var sortedAddresses = List<UtxoAddress>.from(addresses)
      ..sort((a, b) => b.balance.compareTo(a.balance));
    BigInt needFound = amountToSend;
    BigInt tempFound = BigInt.zero;

    List<UtxoAddress> selectedAddresses = [];
    for (var utxo in sortedAddresses) {
      tempFound = needFound;
      needFound -= utxo.balance;
      if (needFound <= BigInt.zero) {
        selectedAddresses.add(utxo.copyWith(
          balance: tempFound,
        ));
        break;
      } else {
        selectedAddresses.add(utxo);
      }
    }

    if (needFound > BigInt.zero) {
      final exception = InsufficientBalanceException(
        availableBalance: needFound,
        requiredBalance: amountToSend,
      );
      debugPrint(exception.toString());
      throw exception;
    }

    return selectedAddresses;
  }

  Future<UserOperation> signUserOperations(BigInt amountToSend,
      String toAddress, Uint8List ephPubKey, String mineAddress) async {
    final approveCallData = encodeErc20ApproveFunctionCall(
      address: Constants.erc5564Announcer,
      amount: amountToSend,
    );
    final sendCallData = encodeSendTokenFunctionCall(
      to: EthereumAddress.fromHex(toAddress),
      tokenAddress: Constants.usdc,
      amount: amountToSend,
      pk: bytesToHex(ephPubKey),
    );

    final callData = encodeExecuteBatchFunctionCall(
        address: EthereumAddress.fromHex(mineAddress),
        params: [
          [
            Constants.usdc,
            Constants.erc5564Announcer,
          ],
          [BigInt.zero, BigInt.zero],
          [approveCallData, sendCallData],
        ]);

    final seed = StealthPrivateKey.getSeedFromAddress(mineAddress);
    final privateKey = StealthPrivateKey.aliceStealthPrivateKey(seed);

    final nonce = await getNonce(EthereumAddress.fromHex(mineAddress));
    debugPrint('=======nonce : $nonce=========');
    String? initCode;
//"0xa0371bd6aeccfee005b49709738e49abce65561d"
    if (nonce == BigInt.zero) {
      final createAccountCallData =
          simpleAccountFactoryContract.function('createAccount').encodeCall([
        privateKey.address,
        Constants.usdc,
        Constants.payMaster,
        BigInt.zero,
      ]);
      initCode =
          '${Constants.simpleAccountFactory.toString()}${bytesToHex(createAccountCallData)}';
    }

    final paymasterAndData =
        "${Constants.payMaster.toString()}${80000.toRadixString(16).padLeft(32, '0')}${80000.toRadixString(16).padLeft(32, '0')}";

    final op = UserOperation.partial(
      initCode: initCode,
      nonce: nonce,
      callData: hexlify(callData),
      paymasterAndData: paymasterAndData,
      sender: EthereumAddress.fromHex(mineAddress),
    );

    final chain = Chains.getChain(Network.sepolia);
    log("op.hash(chain): ${bytesToHex(op.hash(chain), include0x: true)}");
    final signature = EthSigUtil.signPersonalMessage(
      privateKey: bytesToHex(privateKey.privateKey),
      message: op.hash(chain),
    );

    op.signature = signature;

    return op;
  }

  Future<List<UserOperation>> getUserOperations(
      String amountToSend, Uint8List ephPubKey, String toAddress) async {
    final allUtxos = await StealthPrivateKey.getAllUtxo();
    final amount = (double.tryParse(amountToSend) ?? 0.0) * 1000000;
    final rawAmount = BigInt.from(amount);

    final selectedUtxos = await getAddressesToSend(
      addresses: allUtxos,
      amountToSend: rawAmount,
    );

    List<UserOperation> ops = [];
    for (var utxo in selectedUtxos) {
      final op = await signUserOperations(
        utxo.balance,
        toAddress,
        ephPubKey,
        utxo.address,
      );
      ops.add(op);
    }
    return ops;
  }

  Future<String> sendUserOperation(
      String sendAmount, String toAddress, Uint8List ephPubKey) async {
    final ops = await getUserOperations(sendAmount, ephPubKey, toAddress);
    final client = getWeb3Client();

    final cred = EthPrivateKey.fromHex(tempPrivateKey);

    final transaction = Transaction.callContract(
      contract: entryPointContract,
      function: entryPointContract.handleOps,
      parameters: [
        ops.map((e) => e.toList()).toList(),
        Constants.relaterAddress,
      ],
      maxGas: 1000000,
    );
    final hash = await client.sendTransaction(cred, transaction,
        chainId: Chains.getChain(Network.sepolia).chainId);
    return hash;
  }

  String hexlify(List<int> intArray) {
    var ss = <String>[];
    for (int value in intArray) {
      ss.add(value.toRadixString(16).padLeft(2, '0'));
    }
    return "0x${ss.join('')}";
  }

  Future<BigInt> getNonce(EthereumAddress address) async {
    final client = getWeb3Client();

    final nonce = await client.call(
        contract: entryPointContract,
        function: entryPointContract.getNonce,
        params: [
          address,
          BigInt.zero,
        ]);
    return nonce.first;
  }

  final tempPrivateKey =
      'fd9b486761dee2d9d0c508d7699ea30fbce58406c16150bb2e9bc07e381da827';
}
