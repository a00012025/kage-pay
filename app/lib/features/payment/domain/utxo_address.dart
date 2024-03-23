import 'package:freezed_annotation/freezed_annotation.dart';

part 'utxo_address.freezed.dart';
part 'utxo_address.g.dart';

@freezed
class UtxoAddress with _$UtxoAddress {
  const factory UtxoAddress({
    required String address,
    required BigInt balance,
  }) = _UtxoAddress;

  factory UtxoAddress.fromJson(Map<String, dynamic> json) =>
      _$UtxoAddressFromJson(json);
}
