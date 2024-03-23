import 'package:app/features/4337/4337Contract.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  test('test get Address', () async {
    expect(1, 1);
    final client = PaymentService.getWeb3Client();
    final abContract = Deployed4337Contract.create();
    final res = await client.call(
      contract: abContract,
      function: abContract.getAddress,
      params: [
        EthereumAddress.fromHex('0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B'),
        BigInt.zero,
      ],
    );
    expect(res[0].toString(), '0xedabaf73075773757813eec602b6f9ec96c00151');
  });
}
