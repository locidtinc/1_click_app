import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectBoxWidget extends StatelessWidget {
  const SelectBoxWidget({
    super.key,
    this.value,
    this.title,
    this.hintText,
    this.titleStyle,
    this.onTap,
    this.isSelectBox = true,
    this.isSelectTime = false,
  });

  final String? value;
  final String? title;
  final String? hintText;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;
  final bool isSelectBox;
  final bool isSelectTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: titleStyle ?? p4.copyWith(color: borderColor_4),
          ),
        if (title != null) const SizedBox(height: sp8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(sp8),
              border: Border.all(color: borderColor_2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isSelectTime)
                      SvgPicture.asset('${AssetsPath.icon}/ic_clock.svg'),
                    if (isSelectTime) const SizedBox(width: 10),
                    Text(
                      value != null && value!.isNotEmpty ? value! : hintText!,
                      style: value != null && value!.isNotEmpty
                          ? p6
                          : p6.copyWith(color: borderColor_4),
                    )
                  ],
                ),
                if (isSelectBox)
                  Image.asset(
                    '${AssetsPath.icon}/ic_arrow_up.png',
                    width: 9,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
