import 'package:app/features/payment/domain/utxo_address.dart';
import 'package:app/utils/stealth_private_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_addresses_controller.g.dart';

@Riverpod(keepAlive: true)
class UserUtxoAddress extends _$UserUtxoAddress {
  Future<void> updateState() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await StealthPrivateKey.getAllUtxo();
    });
  }

  @override
  FutureOr<List<UtxoAddress>> build() {
    state = const AsyncLoading();
    return StealthPrivateKey.getAllUtxo();
  }
}

String getBalance(List<UtxoAddress> value) {
  if (value.isEmpty) {
    return "0";
  }
  var temp = BigInt.zero;
  for (var i in value) {
    temp += i.balance;
  }
  return (temp / BigInt.from(10).pow(6)).toString();
}
