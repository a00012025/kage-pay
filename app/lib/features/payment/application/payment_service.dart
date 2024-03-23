import 'dart:math';

import 'package:app/features/payment/application/payment_exception.dart';
import 'package:app/features/payment/domain/user_operation.dart';
import 'package:app/features/payment/domain/utxo_address.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  String sendUserOperations(List<UserOperation> userOperations) {
    // Generate a new private key
    var rng = Random.secure();
    Credentials random = EthPrivateKey.createRandom(rng);
    var httpClient = http.Client();
    var client = Web3Client('https://eth-sepolia.g.alchemy.com/v2/demo', httpClient);

    return '';
  }
}
