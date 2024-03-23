import 'dart:convert';
import 'dart:typed_data';

import 'package:app/features/common/constants.dart';
import 'package:app/features/payment/domain/chain.dart';
import 'package:app/features/payment/domain/user_opertation_base.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

Uint8List bigIntToBytes(BigInt number, int byteLength) {
  var hexString = number.toRadixString(16).padLeft(byteLength * 2, '0');
  return Uint8List.fromList(List.generate(byteLength,
      (i) => int.parse(hexString.substring(i * 2, i * 2 + 2), radix: 16)));
}

Uint8List combineBigIntToByte32(BigInt number1, BigInt number2) {
  var halfByteSize = 16;
  var part1 = bigIntToBytes(number1, halfByteSize);
  var part2 = bigIntToBytes(number2, halfByteSize);

  return Uint8List.fromList(part1 + part2);
}

class UserOperation implements UserOperationBase {
  @override
  final EthereumAddress sender;

  @override
  final BigInt nonce;

  @override
  final String initCode;

  @override
  final String callData;

  @override
  final BigInt callGasLimit;

  @override
  final BigInt verificationGasLimit;

  @override
  final BigInt preVerificationGas;

  @override
  BigInt maxFeePerGas;

  @override
  BigInt maxPriorityFeePerGas;

  @override
  String signature;

  @override
  String paymasterAndData;

  final dummySig =
      "0xfffffffffffffffffffffffffffffff0000000000000000000000000000000007aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa1c";

  Uint8List _hash;

  UserOperation({
    required this.sender,
    required this.nonce,
    required this.initCode,
    required this.callData,
    required this.callGasLimit,
    required this.verificationGasLimit,
    required this.preVerificationGas,
    required this.maxFeePerGas,
    required this.maxPriorityFeePerGas,
    required this.signature,
    required this.paymasterAndData,
  }) : _hash = keccak256(abi.encode([
          'address',
          'uint256',
          'bytes32',
          'bytes32',
          'bytes32',
          'uint256',
          'bytes32',
          'bytes32',
        ], [
          sender,
          nonce,
          keccak256(hexToBytes(initCode)),
          keccak256(hexToBytes(callData)),
          combineBigIntToByte32(verificationGasLimit, callGasLimit),
          // callGasLimit,
          // verificationGasLimit,
          preVerificationGas,
          combineBigIntToByte32(maxFeePerGas, maxPriorityFeePerGas),
          // maxFeePerGas,
          // maxPriorityFeePerGas,
          keccak256(hexToBytes(paymasterAndData)),
        ]));

  factory UserOperation.fromJson(String source) =>
      UserOperation.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserOperation.fromMap(Map<String, dynamic> map) {
    return UserOperation(
      sender: EthereumAddress.fromHex(map['sender']),
      nonce: BigInt.parse(map['nonce']),
      initCode: map['initCode'],
      callData: map['callData'],
      callGasLimit: BigInt.parse(map['callGasLimit']),
      verificationGasLimit: BigInt.parse(map['verificationGasLimit']),
      preVerificationGas: BigInt.parse(map['preVerificationGas']),
      maxFeePerGas: BigInt.parse(map['maxFeePerGas']),
      maxPriorityFeePerGas: BigInt.parse(map['maxPriorityFeePerGas']),
      signature: map['signature'],
      paymasterAndData: map['paymasterAndData'],
    );
  }

  factory UserOperation.partial({
    required String callData,
    EthereumAddress? sender,
    BigInt? nonce,
    String? initCode,
    String? paymasterAndData,
    BigInt? callGasLimit,
    BigInt? verificationGasLimit,
    BigInt? preVerificationGas,
    BigInt? maxFeePerGas,
    BigInt? maxPriorityFeePerGas,
  }) =>
      UserOperation(
        sender: sender ?? Constants.zeroAddress,
        nonce: nonce ?? BigInt.zero,
        initCode: initCode ?? "0x",
        callData: callData,
        callGasLimit: callGasLimit ?? BigInt.from(150000),
        verificationGasLimit: verificationGasLimit ?? BigInt.from(500000),
        preVerificationGas: preVerificationGas ?? BigInt.from(500000),
        maxFeePerGas: maxFeePerGas ?? BigInt.from(1000000000),
        maxPriorityFeePerGas: maxPriorityFeePerGas ?? BigInt.from(1000000000),
        signature: "0x",
        paymasterAndData: paymasterAndData ?? '0x',
      );

  @override
  Uint8List hash(Chain chain) => keccak256(abi.encode(
      ['bytes32', 'address', 'uint256'],
      [_hash, chain.entrypoint, BigInt.from(chain.chainId)]));

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender.hexEip55,
      'nonce': '0x${nonce.toRadixString(16)}',
      'initCode': initCode,
      'callData': callData,
      'callGasLimit': '0x${callGasLimit.toRadixString(16)}',
      'verificationGasLimit': '0x${verificationGasLimit.toRadixString(16)}',
      'preVerificationGas': '0x${preVerificationGas.toRadixString(16)}',
      'maxFeePerGas': '0x${maxFeePerGas.toRadixString(16)}',
      'maxPriorityFeePerGas': '0x${maxPriorityFeePerGas.toRadixString(16)}',
      'signature': signature,
      'paymasterAndData': paymasterAndData,
    };
  }

  List<dynamic> toList() {
    return [
      sender,
      nonce,
      hexToBytes(initCode),
      hexToBytes(callData),
      combineBigIntToByte32(verificationGasLimit, callGasLimit),
      preVerificationGas,
      combineBigIntToByte32(maxFeePerGas, maxPriorityFeePerGas),
      hexToBytes(paymasterAndData),
      hexToBytes(signature),
    ];
  }
}
