import 'package:web3dart/web3dart.dart';

class Constants {
  static EthereumAddress entrypoint = EthereumAddress.fromHex(
    "0x0000000071727De22E5E9d8BAf0edAc6f37da032",
  );
  static EthereumAddress zeroAddress =
      EthereumAddress.fromHex("0x0000000000000000000000000000000000000000");
  static EthereumAddress simpleAccountFactory = EthereumAddress.fromHex(
    "0x388Dade543Dfc91e755f870403fE250F31e41583",
  );

  static EthereumAddress receiver = EthereumAddress.fromHex(
    "0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B",
  );

  static EthereumAddress simpleAccount = EthereumAddress.fromHex(
    "0x0051ca20cAD8EDb03fB74536D54467F79D5478c8",
  );

  static EthereumAddress usdc = EthereumAddress.fromHex(
    "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
  );
  static EthereumAddress erc5564Announcer = EthereumAddress.fromHex(
    "0x7356f4cC77168d0e6f94F1d8E28aeA1316852c0d",
  );

  static EthereumAddress relaterAddress = EthereumAddress.fromHex(
    "0xc96Cd4B2499E66698fCa30BaB7e0620A7D919807",
  );
  static EthereumAddress payMaster = EthereumAddress.fromHex(
    "0x49a92D66587909296b18eCa284b20cDAb58D72e9",
  );

  Constants._();
}
