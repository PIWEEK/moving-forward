import 'package:flutter/material.dart';

class MfColors {
  MfColors._(); // this basically makes it so you can instantiate this class

  static const dark = Color(0xFF061134);
  static const gray = Color(0xFF58546B);
  static const light = Color(0xFFD1E5DF);
  static const white = Color(0xFFFFFFFF);
  static const primary = MaterialColor(0xFF18AC91, <int, Color>{
    100: Color(0xFFDBEBE6),
    400: Color(0xFF18AC91),
  });
  static const yellow = Color(0xFFFEF3DE);
  static const blue = Color(0xFFE1EFFF);
  static const red = Color(0xFFFFE1D7);
}
