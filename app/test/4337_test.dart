import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/simple_account_factory_contract.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test get Address', () async {
    final client = PaymentService.getWeb3Client();
    final abContract = SimpleAccountFactoryContract.create();

    final res = await client.call(
      contract: abContract,
      function: abContract.getAddress,
      params: [
        Constants.relaterAddress,
        Constants.usdc,
        Constants.payMaster,
        BigInt.zero,
      ],
    );

    expect(res[0].toString(), Constants.simpleAccount.toString());
  });
}
