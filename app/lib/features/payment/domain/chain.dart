import 'dart:typed_data';

import 'package:app/features/common/constants.dart';
import 'package:web3dart/web3dart.dart';

class Chain {
  final int chainId;
  final String explorer;
  final EthereumAddress entrypoint;
  final EthereumAddress accountFactory;
  String? ethRpcUrl;
  String? bundlerUrl;

  Chain(
      {required this.chainId,
      required this.explorer,
      this.ethRpcUrl,
      this.bundlerUrl,
      required this.entrypoint,
      required this.accountFactory});

  /// asserts that [ethRpcUrl] and [bundlerUrl] is provided
  Chain validate() {
    // require(ethRpcUrl != null && ethRpcUrl!.isNotEmpty,
    // "Chain: please provide a valid eth rpc url");
    // require(bundlerUrl != null && bundlerUrl!.isNotEmpty,
    // "Chain: please provide a valid bundler url");
    return this;
  }
}

class Chains {
  static Map<Network, Chain> chains = {
    // Ethereum Mainnet
    Network.mainnet: Chain(
        chainId: 1,
        explorer: "https://etherscan.io/",
        ethRpcUrl: "https://rpc.ankr.com/eth",
        entrypoint: Constants.entrypoint,
        accountFactory: Constants.simpleAccountFactory),

    // Sepolia Testnet
    Network.sepolia: Chain(
        chainId: 11155111,
        explorer: "https://sepolia.etherscan.io/",
        ethRpcUrl:
            "https://eth-sepolia.g.alchemy.com/v2/DgoQgIklXGSGCY5-7rekG4CiV6nKO-A6",
        entrypoint: Constants.entrypoint,
        accountFactory: Constants.simpleAccountFactory),
  };

  const Chains._();

  static Chain getChain(Network network) {
    return chains[network]!;
  }
}

enum Network {
  // mainnet
  mainnet,

  // testnet
  sepolia,
}

/// Abstract base class for handling Ethereum's Application Binary Interface (ABI).
///
/// The ABI is a data encoding scheme used in Ethereum for ABI encoding
/// and interaction with contracts within Ethereum.
// ignore: camel_case_types
class abi {
  abi._();

  /// Decodes a list of types and values.
  ///
  /// - [types]: A list of string types.
  /// - [value]: A [Uint8List] containing the ABI-encoded data.
  ///
  /// Returns a list of decoded values.
  static List<T> decode<T>(List<String> types, Uint8List value) {
    List<AbiType> abiTypes = [];
    for (String type in types) {
      var abiType = parseAbiType(type);
      abiTypes.add(abiType);
    }
    final parsedData = TupleType(abiTypes).decode(value.buffer, 0);
    return parsedData.data as List<T>;
  }

  /// Encodes a list of types and values.
  ///
  /// - [types]: A list of string types.
  /// - [values]: A list of dynamic values to be encoded.
  ///
  /// Returns a [Uint8List] containing the ABI-encoded types and values.
  static Uint8List encode(List<String> types, List<dynamic> values) {
    List<AbiType> abiTypes = [];
    LengthTrackingByteSink result = LengthTrackingByteSink();
    for (String type in types) {
      var abiType = parseAbiType(type);
      abiTypes.add(abiType);
    }
    TupleType(abiTypes).encode(values, result);
    var resultBytes = result.asBytes();
    result.close();
    return resultBytes;
  }
}
