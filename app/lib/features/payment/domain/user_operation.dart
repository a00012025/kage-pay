import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_operation.freezed.dart';
part 'user_operation.g.dart';

@freezed
class UserOperation with _$UserOperation {
  const factory UserOperation({
    required String sender,
    required int nonce,
    @Default('') String initCode,
    required String callData,
    required int callGas,
    required int verificationGas,
    required int preVerificationGas,
    required int maxFeePerGas,
    required int maxPriorityFeePerGas,
    @Default('') String paymaster,
    @Default('') String paymasterData,
    @Default('') String signature,
  }) = _UserOperation;

  factory UserOperation.fromJson(Map<String, dynamic> json) =>
      _$UserOperationFromJson(json);
}
