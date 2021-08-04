import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static final linkButton = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(const Color(0xFF01b4e4)),
    textStyle: MaterialStateProperty.all(
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
}
