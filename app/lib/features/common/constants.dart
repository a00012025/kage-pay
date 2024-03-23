import 'package:web3dart/web3dart.dart';

class Constants {
  static EthereumAddress entrypoint = EthereumAddress.fromHex(
    "0x0000000071727De22E5E9d8BAf0edAc6f37da032",
  );
  static EthereumAddress zeroAddress =
      EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");
  static EthereumAddress simpleAccountFactory = EthereumAddress.fromHex(
    "0x6f4f6594437d285fa5C7529CE8602Da68d72336f",
  );

  static EthereumAddress receiver = EthereumAddress.fromHex(
    "0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B",
  );

  static EthereumAddress simpleAccount = EthereumAddress.fromHex(
    "0xe005E6A25DEe35E16cA46e9e8c9bBA4D9e92625a",
  );

  static EthereumAddress usdc = EthereumAddress.fromHex(
    "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
  );

  static EthereumAddress myAddress = EthereumAddress.fromHex(
    "0xc96Cd4B2499E66698fCa30BaB7e0620A7D919807",
  );
  static EthereumAddress payMaster = EthereumAddress.fromHex(
    "0xa4Fe52677f2109e1704E765a790619f432BeF959",
  );

  Constants._();
}
