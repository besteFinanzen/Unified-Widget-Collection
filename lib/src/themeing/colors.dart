import 'package:flutter/material.dart';

extension ColorForBrigntess on Brightness {
  Color get color {
    return this == Brightness.light ? Colors.white : Colors.black;
  }
}

extension ContrastForColor on Color {
  Color get contrastColor {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.light ? Colors.black : Colors.white;
  }
}