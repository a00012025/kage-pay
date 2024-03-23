import 'dart:math';

import 'package:app/features/common/contract/factory_contract.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  test('test get Address', () async {
    expect(1, 1);
    final client = PaymentService.getWeb3Client();
    final abContract = FactoryContract.create();

    
    final res = await client.call(
      contract: abContract,
      function: abContract.getAddress,
      params: [
        EthereumAddress.fromHex('0xc96Cd4B2499E66698fCa30BaB7e0620A7D919807'),
        BigInt.zero,
      ],
    );

    expect(res[0].toString(), '0x5c2fa82fbc1af40c014ff03b386ea02589424f41');
  });

  test('test get privateKey', () async {
    expect(1, 1);

    final random = Random.secure();
    final key = EthPrivateKey.createRandom(random);

    print(bytesToHex(key.privateKey));
    print(key.address.hex);

    // expect(res[0].toString(), '0xedabaf73075773757813eec602b6f9ec96c00151');
  });
}
