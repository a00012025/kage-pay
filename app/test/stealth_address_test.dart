// ignore_for_file: avoid_print

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:web3dart/crypto.dart';

void main() {
  test('Stealth address', () async {
    final ECDomainParameters params = ECCurve_secp256k1();
    var rng = Random(123777);

    final alice = StealthPrivateKey.random(rng);
    final bob = StealthPrivateKey.random(rng);
    print('alice: ${alice.kHex()}, ${alice.vHex()}');
    print('bob: ${bob.kHex()}, ${bob.vHex()}');

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
    final bobRecoveredAddress =
        publicKeyToAddress(privateKeyToPublic(stealthPrivateKey));
    print('bobRecoveredAddress: 0x${bytesToHex(bobRecoveredAddress)}');
    assert(bytesToHex(bobStealthAddress) == bytesToHex(bobRecoveredAddress));
  });
}

class StealthPrivateKey {
  final BigInt k;
  final BigInt v;

  StealthPrivateKey(this.k, this.v);

  // new random
  StealthPrivateKey.random(Random rng)
      : k = generateNewPrivateKey(rng),
        v = generateNewPrivateKey(rng);

  @override
  String toString() {
    final kHex = bytesToHex(intToBytes(k));
    final vHex = bytesToHex(intToBytes(v));
    return 'StealthPrivateKey{k: $kHex, v: $vHex}';
  }

  String kHex() {
    return bytesToHex(intToBytes(k));
  }

  String vHex() {
    return bytesToHex(intToBytes(v));
  }

  Uint8List kBytes() {
    return intToBytes(k);
  }

  Uint8List vBytes() {
    return intToBytes(v);
  }

  BigInt kPub() {
    return bytesToUnsignedInt(privateKeyToPublic(k));
  }

  String kPubHex() {
    return bytesToHex(intToBytes(kPub()));
  }

  Uint8List kPubBytes() {
    return privateKeyToPublic(k);
  }

  ECPoint kPubPoint() {
    final x = BigInt.parse(bytesToHex(kPubBytes().sublist(0, 32)), radix: 16);
    final y = BigInt.parse(bytesToHex(kPubBytes().sublist(32)), radix: 16);
    return ECCurve_secp256k1().curve.createPoint(x, y);
  }

  BigInt vPub() {
    return bytesToUnsignedInt(privateKeyToPublic(v));
  }

  String vPubHex() {
    return bytesToHex(intToBytes(vPub()));
  }

  Uint8List vPubBytes() {
    return privateKeyToPublic(v);
  }

  ECPoint vPubPoint() {
    final x = BigInt.parse(bytesToHex(vPubBytes().sublist(0, 32)), radix: 16);
    final y = BigInt.parse(bytesToHex(vPubBytes().sublist(32)), radix: 16);
    return ECCurve_secp256k1().curve.createPoint(x, y);
  }
}
