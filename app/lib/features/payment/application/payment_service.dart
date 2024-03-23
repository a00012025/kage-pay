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
    required List<String> addresses,
    required double amountToSend,
  }) async {
    var sortedAddresses = List<UtxoAddress>.from(addresses)
      ..sort((a, b) => b.balance.compareTo(a.balance));
    double availableBalance = 0.0;

    List<UtxoAddress> selectedAddresses = [];
    for (var utxo in sortedAddresses) {
      selectedAddresses.add(utxo);
      availableBalance += utxo.balance;

      if (availableBalance >= amountToSend) {
        break;
      }
    }

    if (availableBalance < amountToSend) {
      final exception = InsufficientBalanceException(
        availableBalance: availableBalance,
        requiredBalance: amountToSend,
      );
      debugPrint(exception.toString());
      throw exception;
    }

    return selectedAddresses;
  }

  List<UserOperation> getUserOperations() {
    return [];
  }

  Future<UserOperation> signUserOperations(
      BigInt amountToSend, String address, String ephPubKey) async {
    // final innerCallData = encodeErc20TransferFunctionCall(
    //   to: Constants.receiver,
    //   amount: BigInt.from(5000000),
    // );
    final approveCallData = encodeErc20ApproveFunctionCall(
      address: Constants.erc5564Announcer,
      amount: amountToSend,
    );
    final sendCallData = encodeSendTokenFunctionCall(
      to: EthereumAddress.fromHex(address),
      tokenAddress: Constants.usdc,
      amount: amountToSend,
    pk: ephPubKey,
    );

    // final callData =
    //     encodeExecuteFunctionCall(address: Constants.simpleAccount, params: [
    //   Constants.usdc,
    //   BigInt.zero,
    //   innerCallData,
    // ]);

    final callData = encodeExecuteBatchFunctionCall(
        address: Constants.simpleAccount,
        params: [
          [
            Constants.usdc,
            Constants.erc5564Announcer,
          ],
          [BigInt.zero, BigInt.zero],
          [approveCallData, sendCallData],
        ]);

    final nonce = await getNonce();

    String? initCode;

    if (nonce == BigInt.zero) {
      final createAccountCallData =
          simpleAccountFactoryContract.function('createAccount').encodeCall([
        Constants.myAddress,
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
      sender: Constants.simpleAccount,
    );

    final chain = Chains.getChain(Network.sepolia);
    log("op.hash(chain): ${bytesToHex(op.hash(chain), include0x: true)}");
    final signature = EthSigUtil.signPersonalMessage(
      privateKey: tempPrivateKey,
      message: op.hash(chain),
    );

    op.signature = signature;

    return op;
  }

  Future<String> sendUserOperation(String amountToSend, String address) async {
    final amount = (double.tryParse(amountToSend) ?? 0.0) * 1000000;
    final rawAmount = BigInt.from(amount);
    const ephPubKey =
        '0xa0b5593dc1a6f484c011d77a20064ec224e51d4d252785be47ff22e40ad13f52377c6d5a3528fb4d95b0a4b54068a038546214170d50aed1bb2f384e6d73e687';
    final op = await signUserOperations(rawAmount, address, ephPubKey);
    final client = getWeb3Client();

    final cred = EthPrivateKey.fromHex(tempPrivateKey);

    final res = entryPointContract.handleOps.encodeCall(
      [
        [op.toList()],
        Constants.myAddress,
      ],
    );

    log(bytesToHex(res));

    final transaction = Transaction.callContract(
      contract: entryPointContract,
      function: entryPointContract.handleOps,
      parameters: [
        [op.toList()],
        Constants.myAddress,
      ],
      maxGas: 1000000,
    );
    final hash =
        await client.sendTransaction(cred, transaction, chainId: 11155111);
    return hash;
  }

  String hexlify(List<int> intArray) {
    var ss = <String>[];
    for (int value in intArray) {
      ss.add(value.toRadixString(16).padLeft(2, '0'));
    }
    return "0x${ss.join('')}";
  }

  Future<BigInt> getNonce() async {
    final client = getWeb3Client();

    final nonce = await client.call(
        contract: entryPointContract,
        function: entryPointContract.getNonce,
        params: [
          Constants.simpleAccount,
          BigInt.zero,
        ]);
    return nonce.first;
  }

  final tempPrivateKey =
      'fd9b486761dee2d9d0c508d7699ea30fbce58406c16150bb2e9bc07e381da827';
}
