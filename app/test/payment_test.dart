import 'package:app/features/common/constants.dart';
import 'package:app/features/payment/application/payment_exception.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:app/features/payment/domain/utxo_address.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  late final List<UtxoAddress> addresses;
  late final PaymentService paymentService;

  setUpAll(() {
    paymentService = PaymentService();
    addresses = <UtxoAddress>[
      UtxoAddress(address: '0x01', balance: BigInt.from(50.0)),
      UtxoAddress(address: '0x02', balance: BigInt.from(10.0)),
      UtxoAddress(address: '0x03', balance: BigInt.from(30.0)),
    ];
  });

  group('utxo addresses', () {
    test('utxo is insufficient', () {
      var amountToSend = BigInt.from(100);

      expect(() async {
        await paymentService.getAddressesToSend(
          addresses: addresses,
          amountToSend: amountToSend,
        );
      }, throwsA(isA<InsufficientBalanceException>()));
    });

    test('utxo is sufficient, and only `0x01` is selected', () async {
      var amountToSend = BigInt.from(58.0);

      final selectedAddresses = await paymentService.getAddressesToSend(
        addresses: addresses,
        amountToSend: amountToSend,
      );

      var temp = BigInt.zero;
      for (var address in selectedAddresses) {
        temp += address.balance;
      }

      expect(temp, amountToSend);
    });

    test('utxo is sufficient, and `0x01`,`0x03` is selected', () async {
      var amountToSend = BigInt.from(60.0);

      final selectedAddresses = await paymentService.getAddressesToSend(
        addresses: addresses,
        amountToSend: amountToSend,
      );

      expect(selectedAddresses.length, 2);
      expect(selectedAddresses[0].address, '0x01');
      expect(selectedAddresses[1].address, '0x03');
    });

    test('utxo is sufficient, and all addresses is selected', () async {
      var amountToSend = BigInt.from(90.0);

      final selectedAddresses = await paymentService.getAddressesToSend(
        addresses: addresses,
        amountToSend: amountToSend,
      );

      expect(selectedAddresses.length, 3);
      expect(selectedAddresses[0].address, '0x01');
      expect(selectedAddresses[1].address, '0x03');
      expect(selectedAddresses[2].address, '0x02');
    });

    test('utxo is empty', () {
      var amountToSend = BigInt.from(20.0);

      expect(() async {
        await paymentService.getAddressesToSend(
          addresses: [],
          amountToSend: amountToSend,
        );
      }, throwsA(isA<InsufficientBalanceException>()));
    });

    test('utxo is zero', () {
      var amountToSend = BigInt.from(20.0);

      expect(() async {
        await paymentService.getAddressesToSend(
          addresses: [
            UtxoAddress(address: '0x01', balance: BigInt.zero),
          ],
          amountToSend: amountToSend,
        );
      }, throwsA(isA<InsufficientBalanceException>()));
    });
  });

  // test('sign op', () async {
  //   final signedOp = await paymentService.signUserOperations();
  //   print(signedOp.signature);
  // });
  test('get nonce', () async {
    final nonce = await paymentService.getNonce(Constants.simpleAccount);
    print(nonce);
  });
  // test('send op', () async {
  //   final hash = await paymentService.sendUserOperation(
  //     '0.001',
  //     '0x2DE655FEd2140369b1B6767Cd9348F03d8eb7CcE',
  //   );
  //   print(hash);
  // });
}
