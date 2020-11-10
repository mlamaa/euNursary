import 'package:flutter/material.dart';


class MyColors {
  static Color color1 = HexColor("1C3F94");
  static Color color2 = HexColor("FFEF00");
  static Color color3 = HexColor("55B68D");
  static Color color4 = HexColor("EBE4F7"); //
  static Color color5 = HexColor("93CEB3");
  static Color drawer = HexColor("E1D2F4");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}