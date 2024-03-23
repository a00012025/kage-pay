import 'package:flutter_test/flutter_test.dart';
import 'package:variance_dart/variance.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  test('ad', () async {
    expect(1, 1);
    // create smart wallet signer based of seed phrase
    final HDWalletSigner hd = HDWalletSigner.createWallet();
    print("mnemonic: ${hd.exportMnemonic()}");
    final chain = Chain(
        chainId: 1,
        entrypoint: EntryPoint.v06,
        explorer: "",
        jsonRpcUrl: "https://mainnet.infura.io/v3/your_project_id",
        accountFactory: EthereumAddress.fromHex(
          "0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B",
        ));
    // create a smart wallet client
    final walletClient = SmartWallet(
      chain: chain,
      signer: hd,
      bundler: BundlerProvider(chain, RPCProvider(chain.bundlerUrl!)),
    );
    // create a simple account based on hd
    // random salt
    final salt = Uint256.fromString("key");
    final SmartWallet simpleSmartAccount =
        await walletClient.createSimpleAccount(salt);
    print("simple account address: ${simpleSmartAccount.address}");

    // get the init code of the smart wallet
    final String initCode = simpleSmartAccount.initCode;
    print("account init code: $initCode");
  });
}
