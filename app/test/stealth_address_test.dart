// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:typed_data';

import 'package:app/features/common/constants.dart';
import 'package:app/features/common/contract/entry_point_contract.dart';
import 'package:app/features/common/contract/simple_account_factory_contract.dart';
import 'package:app/features/payment/application/payment_service.dart';
import 'package:app/features/stealth/stealth_service.dart';
import 'package:app/utils/stealth_private_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:web3dart/crypto.dart';

void main() {
  test('get usdc balance', () async {
    final contract = EntryPointContract.create();
    for (var i = 1; i < 4; i++) {
      final client = PaymentService.getWeb3Client();
      final res = await client.call(
        contract: contract,
        function: contract.getNonce,
        params: [
          StealthPrivateKey.aliceStealthPrivateKey(i).address,
          BigInt.zero,
        ],
      );
      print(res);
    }
  });
  // test('get usdc balance', () async {
  //   final erc20 = Erc20Contract.create();
  //   for (var i = 1; i < 4; i++) {
  //     final client = PaymentService.getWeb3Client();
  //     final res = await client.call(
  //       contract: erc20,
  //       function: erc20.balanceOf,
  //       params: [
  //         StealthPrivateKey.getAliceContractAddress(i),
  //       ],
  //     );
  //     print(res);
  //   }
  // });
  test('alice stealth address', () async {
    for (var i = 1; i < 4; i++) {
      final privateKey = StealthPrivateKey.aliceStealthPrivateKey(i);

      final simpleAccount = SimpleAccountFactoryContract.create();

      final client = PaymentService.getWeb3Client();
      final res = await client.call(
        contract: simpleAccount,
        function: simpleAccount.getAddress,
        params: [
          privateKey.address,
          Constants.usdc,
          Constants.payMaster,
          BigInt.zero,
        ],
      );
      print(res);
    }
  });
  test('stealth service', () {
    final service = StealthService();

    final vPubPoint = service.getECPoint(
        '0xeb3e0a595b8ca73c46a4d083604f2023705d567757b543b9d3c189ad266905bd1db06b9166152bec3d2fd95a102e674e571d02bc0a66a886ede372c37ace82d7');
    final kPubPoint = service.getECPoint(
        '0xe4fa494ae6778a7f92a5f88b8c594699c7dee9e8a7bf105c68a9be48fd5ffa3736441828fb7a5a76f360341183197aa94e6aa7bcab44c7169dee9444142bb978');
    final result = service.getOthersAddress(vPubPoint, kPubPoint);
    debugPrint('=======result : $result=========');
  });
  test('Stealth address', () async {
    final ECDomainParameters params = ECCurve_secp256k1();
    var rng = Random(123777);

    final alice = StealthPrivateKey.random(rng);
    print(alice.k);
    print(alice.v);
    final bob = StealthPrivateKey.random(rng);
    print('alice: ${alice.kHex()}, ${alice.vHex()}');
    print('bob k and v: ${bob.kHex()}, ${bob.vHex()}');
    print('bob K and V: ${bob.kPubHex()}, ${bob.vPubHex()}');

    // alice sending token to bob, generating shared secret
    final r = generateNewPrivateKey(rng);
    final rPubPoint = (params.G * r)!;
    final shared1 = (bob.vPubPoint() * r)!;
    final shared2 = (rPubPoint * bob.v)!;
    assert(shared1 == shared2);
    final sharedSecret = shared1.x!.toBigInteger()!;
    print("sharedSecret: ${bytesToHex(intToBytes(sharedSecret))}");
    final bobStealthPoint = (bob.kPubPoint() + (params.G * sharedSecret)!)!;
    final bobStealthPubKey =
        Uint8List.view(bobStealthPoint.getEncoded(false).buffer, 1);
    final bobStealthAddress = publicKeyToAddress(bobStealthPubKey);
    print('bobStealthAddress: 0x${bytesToHex(bobStealthAddress)}');

    // alice calculate announcement
    final ephemeralPubKey =
        Uint8List.view(rPubPoint.getEncoded(false).buffer, 1);
    print("Alice broadcast ephemeralPubKey: 0x${bytesToHex(ephemeralPubKey)}");

    // bob calculate shared secret
    final bobX =
        BigInt.parse(bytesToHex(ephemeralPubKey.sublist(0, 32)), radix: 16);
    final bobY =
        BigInt.parse(bytesToHex(ephemeralPubKey.sublist(32)), radix: 16);
    final bobSharedSecret =
        (ECCurve_secp256k1().curve.createPoint(bobX, bobY) * bob.v)!
            .x!
            .toBigInteger()!;
    print("bobSharedSecret: ${bytesToHex(intToBytes(bobSharedSecret))}");
    final stealthPrivateKey = bob.k + bobSharedSecret;
    print("stealthPrivateKey: 0x${bytesToHex(intToBytes(stealthPrivateKey))}");
    final stPubKey = privateKeyToPublic(stealthPrivateKey);

    final Gx = params.G.x!.toBigInteger()!;
    final Gy = params.G.y!.toBigInteger()!;
    print("Gx: ${bytesToHex(intToBytes(Gx))}");
    print("Gy: ${bytesToHex(intToBytes(Gy))}");

    print("stealthPublicKey: ${bytesToHex(stPubKey)}");
    final bobRecoveredAddress =
        publicKeyToAddress(privateKeyToPublic(stealthPrivateKey));
    print('bobRecoveredAddress: 0x${bytesToHex(bobRecoveredAddress)}');
    assert(bytesToHex(bobStealthAddress) == bytesToHex(bobRecoveredAddress));

    var rng2 = Random(3232);
    final r2 = generateNewPrivateKey(rng2);
    final r2PubPoint = (params.G * r2)!;
    final ephemeralPubKey2 =
        Uint8List.view(r2PubPoint.getEncoded(false).buffer, 1);
    print(
        "Charles broadcast ephemeralPubKey: 0x${bytesToHex(ephemeralPubKey2)}");
    final sharedSecret2 = (bob.vPubPoint() * r2)!.x!.toBigInteger()!;
    final bobStealthPoint2 = (bob.kPubPoint() + (params.G * sharedSecret2)!)!;
    final bobStealthPubKey2 =
        Uint8List.view(bobStealthPoint2.getEncoded(false).buffer, 1);
    final bobStealthAddress2 = publicKeyToAddress(bobStealthPubKey2);
    print('bobStealthAddress: 0x${bytesToHex(bobStealthAddress2)}');
  });
}
