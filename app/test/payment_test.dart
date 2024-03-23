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
      const UtxoAddress(address: '0x01', balance: 50.0),
      const UtxoAddress(address: '0x02', balance: 10.0),
      const UtxoAddress(address: '0x03', balance: 30.0),
    ];
  });

  group('utxo addresses', () {
    test('utxo is insufficient', () {
      const amountToSend = 100.0;

      expect(() {
        paymentService.getAddressesToSend(
          addresses: addresses,
          amountToSend: amountToSend,
        );
      }, throwsA(isA<InsufficientBalanceException>()));
    });

    test('utxo is sufficient, and only `0x01` is selected', () {
      const amountToSend = 50.0;

      final selectedAddresses = paymentService.getAddressesToSend(
        addresses: addresses,
        amountToSend: amountToSend,
      );

      expect(selectedAddresses.length, 1);
      expect(selectedAddresses[0].address, '0x01');
    });

    test('utxo is sufficient, and `0x01`,`0x03` is selected', () {
      const amountToSend = 60.0;

      final selectedAddresses = paymentService.getAddressesToSend(
        addresses: addresses,
        amountToSend: amountToSend,
      );

      expect(selectedAddresses.length, 2);
      expect(selectedAddresses[0].address, '0x01');
      expect(selectedAddresses[1].address, '0x03');
    });

    test('utxo is sufficient, and all addresses is selected', () {
      const amountToSend = 90.0;

      final selectedAddresses = paymentService.getAddressesToSend(
        addresses: addresses,
        amountToSend: amountToSend,
      );

      expect(selectedAddresses.length, 3);
      expect(selectedAddresses[0].address, '0x01');
      expect(selectedAddresses[1].address, '0x03');
      expect(selectedAddresses[2].address, '0x02');
    });

    test('utxo is empty', () {
      const amountToSend = 20.0;

      expect(() {
        paymentService.getAddressesToSend(
          addresses: [],
          amountToSend: amountToSend,
        );
      }, throwsA(isA<InsufficientBalanceException>()));
    });

    test('utxo is zero', () {
      const amountToSend = 20.0;

      expect(() {
        paymentService.getAddressesToSend(
          addresses: [
            const UtxoAddress(address: '0x01', balance: 0.0),
          ],
          amountToSend: amountToSend,
        );
      }, throwsA(isA<InsufficientBalanceException>()));
    });
  });

  test('sign op', () {
    final signedOp = paymentService.signUserOperations();
    print(signedOp.signature);
  });
  test('send op', () async {
    final signedOp = paymentService.signUserOperations();
    print(signedOp.signature);

    final hash = await paymentService.sendUserOperation(signedOp);
    print(hash);
  });
}
