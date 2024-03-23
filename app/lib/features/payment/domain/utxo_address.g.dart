// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utxo_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UtxoAddressImpl _$$UtxoAddressImplFromJson(Map<String, dynamic> json) =>
    _$UtxoAddressImpl(
      address: json['address'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$UtxoAddressImplToJson(_$UtxoAddressImpl instance) =>
    <String, dynamic>{
      'address': instance.address,
      'balance': instance.balance,
    };
