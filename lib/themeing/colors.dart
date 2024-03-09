import 'package:flutter/material.dart';

extension ContrastColor on Brightness {
  Color get color {
    return this == Brightness.light ? Colors.white : Colors.black;
  }
}