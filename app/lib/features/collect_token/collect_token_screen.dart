import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:app/features/common/contract/erc20_contract.dart';
import 'package:app/features/common/contract/message_transmitter.dart';
import 'package:app/features/common/contract/token_messenger_contract.dart';
import 'package:app/utils/default_button.dart';
import 'package:app/utils/gaps.dart';
import 'package:app/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class CollectTokenScreen extends ConsumerStatefulWidget {
  const CollectTokenScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CollectTokenState();
}

const privateKey =
    '0xd469da6003c673ad173f23e7feff16b9409256f98080ab07c9098ae80ec29e5d';
const address = '0xa816f8caa03c8A40De7E7B724398a6200AE8c266';
const mumbaiUsdcAddress = '0x9999f7Fea5938fD3b1E26A12c3f2fb024e194f97';
const opSepoliaUsdcAddress = '0x5fd84259d66Cd46123540766Be93DFE6D43130D7';
var mumbaiWeb3Client =
    Web3Client('https://rpc.ankr.com/polygon_mumbai', http.Client());
var opSepoliaWeb3Client = Web3Client(
    'https://public.stackup.sh/api/v1/node/optimism-sepolia', http.Client());
final mumbaiUsdc = Erc20Contract(
  ContractAbi.fromJson(jsonEncode(erc20Abi), 'USDC'),
  EthereumAddress.fromHex(mumbaiUsdcAddress),
);
final mumbaiTokenMessenger = TokenMessengerContract(
    EthereumAddress.fromHex("0x9f3B8679c73C2Fef8b59B4f3444d4e156fb70AA5"));
final mumbaiMessageTransmitter = MessageTransmitterContract(
    EthereumAddress.fromHex("0xe09A679F56207EF33F5b9d8fb4499Ec00792eA73"));
final opSepoliaUsdc = Erc20Contract(
  ContractAbi.fromJson(jsonEncode(erc20Abi), 'USDC'),
  EthereumAddress.fromHex(opSepoliaUsdcAddress),
);
final opSepoliaMessageTransmitter = MessageTransmitterContract(
    EthereumAddress.fromHex("0x7865fAfC2db2093669d92c0F33AeEF291086BEFD"));

class _CollectTokenState extends ConsumerState<CollectTokenScreen> {
  final textEditingController = TextEditingController();

  // loading state
  var isLoading = true;
  var usdcMumbaiBalance = 0.0;
  var usdcOpSepoliaBalance = 0.0;

  @override
  void initState() {
    super.initState();
    refreshBalance().catchError((error) {
      log(error.toString());
    });
  }

  Future<void> refreshBalance() async {
    final [balance1, balance2] = await Future.wait([
      mumbaiWeb3Client.call(
          contract: mumbaiUsdc,
          function: mumbaiUsdc.balanceOf,
          params: [EthereumAddress.fromHex(address)]),
      opSepoliaWeb3Client.call(
          contract: opSepoliaUsdc,
          function: opSepoliaUsdc.balanceOf,
          params: [EthereumAddress.fromHex(address)]),
    ]);
    setState(() {
      usdcMumbaiBalance = balance1[0] / BigInt.from(10).pow(6);
      usdcOpSepoliaBalance = balance2[0] / BigInt.from(10).pow(6);
      isLoading = false;
      customToast("Collect Success");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/polygon.jpg', width: 20),
                    Gaps.w4,
                    const Text(
                      'Polygon Mumbai',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${usdcMumbaiBalance.toString()} usdc',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Gaps.h12,
          !isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: 150,
                        child: TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            hintText: 'Enter amount',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Gaps.w8,
                    Column(
                      children: [
                        DefaultButton(
                          onPressed: () {
                            setState(() {
                              isLoading = true;
                            });
                            mumbaiUsdcToOpSepolia(textEditingController.text)
                                .then((_) async {
                              await refreshBalance();
                            }).catchError((error) {
                              log(error.toString());
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/icons/collect.png',
                                width: 32,
                              )),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.swap_vert_outlined),
                            Text("Collect"),
                          ],
                        )
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    DefaultButton(
                      onPressed: () {},
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/icons/collect.png',
                            width: 32,
                          )
                              .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true))
                              .rotate(
                                duration: const Duration(milliseconds: 2000),
                                curve: Curves.easeInOutExpo,
                              )
                              .scale(
                                duration: const Duration(milliseconds: 2000),
                                begin: const Offset(0.2, 0.2),
                                curve: Curves.easeInOutExpo,
                              )),
                    ),
                    const Text("Loading")
                  ],
                ),

          Gaps.h12,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/icons/op.jpg', width: 20),
                    Gaps.w4,
                    const Text(
                      'Op Sepolia',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${usdcOpSepoliaBalance.toString()} usdc',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          // Gaps.h12,
          // const Center(
          //   child: Text(
          //     'Transfer USDC from Op Sepolia to Mumbai',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          // Gaps.h12,
          // !isLoading
          //     ? DefaultButton(
          //         onPressed: () {
          //           setState(() {
          //             isLoading = true;
          //           });
          //           Future.delayed(const Duration(seconds: 5), () {
          //             setState(() {
          //               isLoading = false;
          //             });
          //           });
          //         },
          //         child: Padding(
          //           padding: const EdgeInsets.all(12.0),
          //           child: Image.asset(
          //             'assets/icons/send.png',
          //             width: 32,
          //           ),
          //         ),
          //       )
          //     : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

Future<void> mumbaiUsdcToOpSepolia(String amountStr) async {
  final amount = (double.tryParse(amountStr) ?? 0.0) * 1000000;
  final rawAmount = BigInt.from(amount);

  final nonce = await mumbaiWeb3Client.getTransactionCount(
    EthereumAddress.fromHex(address),
    atBlock: const BlockNum.pending(),
  );

  var txHash = await mumbaiWeb3Client.sendTransaction(
    EthPrivateKey.fromHex(privateKey),
    Transaction.callContract(
      contract: mumbaiUsdc,
      function: mumbaiUsdc.approve,
      parameters: [
        EthereumAddress.fromHex("0x9f3B8679c73C2Fef8b59B4f3444d4e156fb70AA5"),
        rawAmount,
      ],
      nonce: nonce,
    ),
    chainId: 80001,
  );
  log('Sent tx1 hash: $txHash');
  while (true) {
    final r = await mumbaiWeb3Client.getTransactionReceipt(txHash);
    if (r != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 1));
  }
  txHash = await mumbaiWeb3Client.sendTransaction(
    EthPrivateKey.fromHex(privateKey),
    Transaction.callContract(
      contract: mumbaiTokenMessenger,
      function: mumbaiTokenMessenger.depositForBurn,
      parameters: [
        rawAmount,
        BigInt.from(2), // OP
        hexToBytes('0x000000000000000000000000${address.substring(2)}'),
        EthereumAddress.fromHex(mumbaiUsdcAddress),
      ],
      nonce: nonce + 1,
    ),
    chainId: 80001,
  );
  log('Sent tx2 hash: $txHash');
  TransactionReceipt receipt;
  while (true) {
    final r = await mumbaiWeb3Client.getTransactionReceipt(txHash);
    if (r != null) {
      receipt = r;
      break;
    }
    await Future.delayed(const Duration(seconds: 3));
  }
  final messageSentLog = receipt.logs.firstWhere((log) =>
      log.topics != null &&
      log.topics![0] ==
          "0x8c5261668696ce22758910d05bab8f186d6eb247ceac2af2e82c7dc17669b036");
  final decodedResult = mumbaiMessageTransmitter.messageSentEvent
      .decodeResults(messageSentLog.topics!, messageSentLog.data!);
  final messageBytes = decodedResult[0] as Uint8List;
  final messageHash = bytesToHex(keccak256(messageBytes), include0x: true);
  log('Message hash: $messageHash');

  // wait for the message to be attested
  String attestation;
  while (true) {
    final response = await http.get(Uri.parse(
        'https://iris-api-sandbox.circle.com/attestations/$messageHash'));
    if (response.statusCode == 200) {
      // try to parse the response
      final json = jsonDecode(response.body);
      if (json['attestation'] != null && json['attestation'] != 'PENDING') {
        attestation = json['attestation'];
        break;
      }
    }
    log('Response: ${response.body}');
    await Future.delayed(const Duration(seconds: 1));
  }
  log('Got attestation result: $attestation');

  // claim usdc on op
  txHash = await opSepoliaWeb3Client.sendTransaction(
    EthPrivateKey.fromHex(privateKey),
    Transaction.callContract(
      contract: opSepoliaMessageTransmitter,
      function: opSepoliaMessageTransmitter.receiveMessage,
      parameters: [
        messageBytes,
        hexToBytes(attestation),
      ],
    ),
    chainId: 11155420,
  );
  log('Sent tx3 hash: $txHash');
  while (true) {
    final r = await opSepoliaWeb3Client.getTransactionReceipt(txHash);
    if (r != null) {
      break;
    }
    await Future.delayed(const Duration(seconds: 3));
  }
  log('Claimed USDC on Op Sepolia!');
}
