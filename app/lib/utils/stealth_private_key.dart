import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

typedef AddressPirvateKey = (String address, String privateKey);

class StealthPrivateKey {
  final BigInt k;
  final BigInt v;

  StealthPrivateKey(this.k, this.v);

  static StealthPrivateKey get alice {
    return StealthPrivateKey(
      BigInt.parse(
          "61930824511912595429206811402568183081408216245750760436263091246199513413718"),
      BigInt.parse(
          "73962569226937429975353181806669569903570248713875834875957825741114699041660"),
    );
  }

  static AddressPirvateKey aliceAddressPrivateKey(int seed) {
    final alice = StealthPrivateKey.alice;
    final ECDomainParameters params = ECCurve_secp256k1();

    // final staticRandom = Random(seed);
    // final r = generateNewPrivateKey(staticRandom);
    final r = BigInt.from(seed);
    final rPubPoint = (params.G * r)!;
    // alice calculate announcement
    final ephemeralPubKey =
        Uint8List.view(rPubPoint.getEncoded(false).buffer, 1);

    final aliceX =
        BigInt.parse(bytesToHex(ephemeralPubKey.sublist(0, 32)), radix: 16);
    final aliceY =
        BigInt.parse(bytesToHex(ephemeralPubKey.sublist(32)), radix: 16);
    final aliceSharedSecret =
        (ECCurve_secp256k1().curve.createPoint(aliceX, aliceY) * alice.v)!
            .x!
            .toBigInteger()!;
    final stealthPrivateKey = alice.k + aliceSharedSecret;

    final truePrivateKey =
        bytesToHex(intToBytes(stealthPrivateKey)).replaceFirst("01", "");
    final address = EthPrivateKey.fromHex(truePrivateKey).address.hex;
    return (
      address,
      truePrivateKey,
    );
  }

  get sharedSecret {
    final shared1 = (vPubPoint() * k)!;
    final shared2 = (kPubPoint() * v)!;
    assert(shared1 == shared2);
    return shared1.x!.toBigInteger()!;
  }

  String toEncodeStr(String name) {
    final map = {
      "pk": kPubHex(include0x: true),
      "pv": vPubHex(include0x: true),
      "name": name
    };
    return jsonEncode(map);
  }

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
    return bytesToHex(
      intToBytes(k),
    );
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

  String kPubHex({bool include0x = false}) {
    var z = bytesToHex(intToBytes(kPub()));
    if (z.startsWith("00")) {
      z = z.substring(2);
    }
    return include0x ? "0x$z" : z;
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

  String vPubHex({bool include0x = false}) {
    return bytesToHex(intToBytes(vPub()), include0x: include0x);
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
