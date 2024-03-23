import 'package:app/feat/payment/application/payment_exception.dart';
import 'package:app/feat/payment/domain/utxo_address.dart';
import 'package:flutter/foundation.dart';

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
}
