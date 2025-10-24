import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class BaseCheckboxV2 extends StatelessWidget {
  const BaseCheckboxV2({
    super.key,
    required this.value,
    required this.onChanged,
    this.fillColor,
    this.checkColor,
  });

  final bool value;
  final Function(bool? value) onChanged;
  final Color? fillColor;
  final Color? checkColor;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sp4)),
      side: const BorderSide(width: 2, color: greyColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: 2, vertical: 2),
      splashRadius: sp8,
      checkColor: mainColor,
      fillColor: WidgetStateProperty.all(whiteColor),
      value: value,
      onChanged: (value) {
        onChanged.call(value);
      },
    );
  }
}
