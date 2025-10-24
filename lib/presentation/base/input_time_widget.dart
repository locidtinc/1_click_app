import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class InputTimeWidget extends StatelessWidget {
  const InputTimeWidget({
    super.key,
    this.label,
    this.hintText,
    this.onTap,
    this.onChanged,
  });

  final String? label;
  final String? hintText;
  final Function? onTap;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          RichText(
            text: TextSpan(
              text: label,
              style: p4.copyWith(color: borderColor_4),
            ),
          ),
        // Text('$label', style: p5),
        if (label != null) const SizedBox(height: sp8),
        TextFormField(
          onTap: () {
            if (onTap != null) onTap!();
          },
          onChanged: (String? value) {
            if (value != null && onChanged != null) {
              onChanged!(value);
            }
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: borderColor_2,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: borderColor_2,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: borderColor_2,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: blue_1,
                width: 1,
              ),
            ),
            hintText: hintText,
            hintStyle: p6.copyWith(color: greyColor),
            prefixIcon: const Padding(
              padding: EdgeInsets.all(sp8),
              child: Icon(
                Icons.watch_later_outlined,
                size: 20,
                color: blackColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
