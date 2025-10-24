import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class BaseSwitch extends StatelessWidget {
  const BaseSwitch({
    super.key,
    required this.value,
    required this.onToggle,
  });

  final bool value;
  final Function(bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 25,
      height: 15,
      activeColor: mainColor,
      valueFontSize: 0,
      toggleSize: 10,
      value: value,
      borderRadius: 30.0,
      padding: 3,
      showOnOff: false,
      onToggle: (val) => onToggle(val),
    );
  }
}
