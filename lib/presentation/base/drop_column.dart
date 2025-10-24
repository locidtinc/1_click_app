import 'package:flutter/material.dart';
import 'package:one_click/presentation/base/custom_drop_down.dart';
import 'package:one_click/presentation/base/dimensions.dart';
import 'package:one_click/presentation/shared_view/widget/fa_icon.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

Widget DropDownColumn<T>({
  required String label,
  bool isRequired = false,
  List<DropdownMenuItem<T>>? items,
  Function(T?)? onChanged,
  T? value,
  EdgeInsets? padding,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? hintText,
}) {
  return Padding(
    padding: padding ?? (Dimensions.sp16.padingTop + Dimensions.sp16.padingHor),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.bodyBsMedium.copyWith(
              color: AppColors.input_label,
            ),
            children: [
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_brand_primary_variant2,
                  ),
                ),
            ],
          ),
        ),
        Dimensions.sp8.height,
        CustomDropDown<T>(
          value: value,
          onChanged: onChanged,
          items: items,
          hintText: hintText ?? 'Chọn ${label.toLowerCase()}',
          hintAlign: TextAlign.center,
          showIconRemove: false,
          color: AppColors.white,
          radius: 8,
          borderColor: AppColors.input_borderDefault,
          required: isRequired,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 21,
          ),
          validate: (p0) {
            if (p0 == null && isRequired) {
              return 'Vui lòng chọn ${label.toLowerCase()}';
            }
            return null;
          },
        ),
      ],
    ),
  );
}
