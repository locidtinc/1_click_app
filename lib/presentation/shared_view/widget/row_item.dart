import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
    required this.title,
    required this.content,
    this.contetnColor,
    this.titleColor,
  });

  final String title;
  final String content;
  final Color? contetnColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: p6.copyWith(color: titleColor ?? blackColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            content.isEmpty ? 'Chưa có thông tin' : content,
            style: h6.copyWith(color: contetnColor ?? blackColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
