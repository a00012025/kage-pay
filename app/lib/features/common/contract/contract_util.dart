import 'dart:typed_data';

import 'package:app/features/common/contract/erc20_contract.dart';
import 'package:app/features/common/contract/erc5564_announcer_contract.dart';
import 'package:app/features/common/contract/simple_account_contract.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

Uint8List encodeExecuteFunctionCall(
    {required EthereumAddress address, required List<dynamic> params}) {
  final contract = SimpleAccountContract.create(
    address: address,
  );
  return contract.execute.encodeCall(params);
}

Uint8List encodeExecuteBatchFunctionCall(
    {required EthereumAddress address, required List<dynamic> params}) {
  final contract = SimpleAccountContract.create(
    address: address,
  );
  return contract.executeBatch.encodeCall(params);
}

Uint8List encodeErc20TransferFunctionCall({
  required EthereumAddress to,
  required BigInt amount,
}) {
  final contract = Erc20Contract.create();
  return contract.transfer.encodeCall([
    to,
    amount,
  ]);
}

Uint8List encodeErc20ApproveFunctionCall({
  required EthereumAddress address,
  required BigInt amount,
}) {
  final contract = Erc20Contract.create();
  return contract.approve.encodeCall([
    address,
    amount,
  ]);
}

Uint8List encodeSendTokenFunctionCall({
  required EthereumAddress to,
  required EthereumAddress tokenAddress,
  required BigInt amount,
  required pk,
}) {
  final contract = Erc5564AnnouncerContract.create();
  return contract.sendToken.encodeCall([
    to,
    tokenAddress,
    amount,
    hexToBytes(pk),
  ]);
}
