import 'dart:developer';

import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/contract_util.dart';
import 'package:app/features/common/contract/entry_point_contract.dart';
import 'package:app/features/common/contract/factory_contract.dart';
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
  List<UtxoAddress> getAddressesToSend({
    required List<UtxoAddress> addresses,
    required double amountToSend,
  }) {
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

  static Web3Client getWeb3Client() {
    var httpClient = http.Client();
    return Web3Client('https://eth-sepolia.public.blastapi.io', httpClient);
  }

  UserOperation signUserOperations() {
    final innerCallData = encodeErc20TransferFunctionCall(
      to: Constants.receiver,
      amount: BigInt.from(1),
    );

    final callData =
        encodeExecuteFunctionCall(address: Constants.simpleAccount, params: [
      Constants.usdc,
      BigInt.from(0),
      innerCallData,
    ]);

    final createAccountCallData =
        FactoryContract.create().function('createAccount').encodeCall([
      Constants.myAddress,
      Constants.usdc,
      Constants.payMaster,
      BigInt.from(0),
    ]);

    final initCode =
        '${Constants.simpleAccountFactory.toString()}${bytesToHex(createAccountCallData)}';

    final paymasterAndData =
        "${Constants.payMaster.toString()}${80000.toRadixString(16).padLeft(32, '0')}${80000.toRadixString(16).padLeft(32, '0')}";

    final op = UserOperation.partial(
      initCode: initCode,
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

  Future<String> sendUserOperation(UserOperation op) async {
    final client = getWeb3Client();

    final cred = EthPrivateKey.fromHex(tempPrivateKey);

    final contract = EntryPointContract.create();
    final res = contract.handleOps.encodeCall(
      [
        [op.toList()],
        Constants.myAddress,
      ],
    );

    log(bytesToHex(res));

    final transaction = Transaction.callContract(
      contract: contract,
      function: contract.handleOps,
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

  final tempPrivateKey =
      'fd9b486761dee2d9d0c508d7699ea30fbce58406c16150bb2e9bc07e381da827';
}
