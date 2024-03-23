import 'package:flutter/material.dart';

@immutable
final class Gaps {
  const Gaps._();

  static const w4 = SizedBox(width: Spacings.px4);
  static const w8 = SizedBox(width: Spacings.px8);
  static const w12 = SizedBox(width: Spacings.px12);
  static const w16 = SizedBox(width: Spacings.px16);
  static const w20 = SizedBox(width: Spacings.px20);
  static const w24 = SizedBox(width: Spacings.px24);
  static const w32 = SizedBox(width: Spacings.px32);
  static const w48 = SizedBox(width: Spacings.px48);
  static const w64 = SizedBox(width: Spacings.px64);

  static const h4 = SizedBox(height: Spacings.px4);
  static const h8 = SizedBox(height: Spacings.px8);
  static const h12 = SizedBox(height: Spacings.px12);
  static const h16 = SizedBox(height: Spacings.px16);
  static const h20 = SizedBox(height: Spacings.px20);
  static const h24 = SizedBox(height: Spacings.px24);
  static const h32 = SizedBox(height: Spacings.px32);
  static const h40 = SizedBox(height: Spacings.px40);
  static const h48 = SizedBox(height: Spacings.px48);
  static const h64 = SizedBox(height: Spacings.px64);
  static const h84 = SizedBox(height: Spacings.px84);
}

@immutable
final class Spacings {
  const Spacings._();

  static const px4 = 4.0;
  static const px8 = 8.0;
  static const px12 = 12.0;
  static const px16 = 16.0;
  static const px20 = 20.0;
  static const px24 = 24.0;
  static const px32 = 32.0;
  static const px40 = 40.0;
  static const px48 = 48.0;
  static const px64 = 64.0;
  static const px84 = 84.0;
  static const px100 = 100.0;
}
