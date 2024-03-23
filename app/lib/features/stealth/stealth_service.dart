import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:web3dart/crypto.dart';

typedef StealthAddressAndEphemeralPubKey = (
  String address,
  Uint8List ephemeralPubKey
);

class StealthService {
  final rng = Random.secure();
  final ECDomainParameters params = ECCurve_secp256k1();

  ECPoint getECPoint(String hex) {
    final x =
        BigInt.parse(hex.replaceAll("0x", "").substring(0, 64), radix: 16);
    final y = BigInt.parse(hex.replaceAll("0x", "").substring(64), radix: 16);
    return ECCurve_secp256k1().curve.createPoint(x, y);
  }

  StealthAddressAndEphemeralPubKey getOthersAddress(
      ECPoint vPubPoint, ECPoint kPubPoint) {
    final r = generateNewPrivateKey(rng);
    final rPubPoint = (params.G * r)!;
    final shared1 = (vPubPoint * r)!;

    final sharedSecret = shared1.x!.toBigInteger()!;
    final bobStealthPoint = (kPubPoint + (params.G * sharedSecret)!)!;
    final bobStealthPubKey =
        Uint8List.view(bobStealthPoint.getEncoded(false).buffer, 1);
    final bobStealthAddress = publicKeyToAddress(bobStealthPubKey);

    final ephemeralPubKey =
        Uint8List.view(rPubPoint.getEncoded(false).buffer, 1);
    return (bytesToHex(bobStealthAddress, include0x: true), ephemeralPubKey);
  }
}
