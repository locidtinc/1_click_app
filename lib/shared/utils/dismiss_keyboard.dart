import 'package:flutter/material.dart';

class AppUtils {
  static void dissmissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
