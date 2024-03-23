// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserOperationImpl _$$UserOperationImplFromJson(Map<String, dynamic> json) =>
    _$UserOperationImpl(
      sender: json['sender'] as String,
      nonce: json['nonce'] as int,
      initCode: json['initCode'] as String? ?? '',
      callData: json['callData'] as String,
      callGas: json['callGas'] as int,
      verificationGas: json['verificationGas'] as int,
      preVerificationGas: json['preVerificationGas'] as int,
      maxFeePerGas: json['maxFeePerGas'] as int,
      maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as int,
      paymaster: json['paymaster'] as String? ?? '',
      paymasterData: json['paymasterData'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
    );

Map<String, dynamic> _$$UserOperationImplToJson(_$UserOperationImpl instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'nonce': instance.nonce,
      'initCode': instance.initCode,
      'callData': instance.callData,
      'callGas': instance.callGas,
      'verificationGas': instance.verificationGas,
      'preVerificationGas': instance.preVerificationGas,
      'maxFeePerGas': instance.maxFeePerGas,
      'maxPriorityFeePerGas': instance.maxPriorityFeePerGas,
      'paymaster': instance.paymaster,
      'paymasterData': instance.paymasterData,
      'signature': instance.signature,
    };
