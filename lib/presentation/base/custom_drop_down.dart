import 'package:base_mykiot/base_lhe.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:one_click/presentation/base/dimensions.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

class CustomDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>>? items;
  final Function(T?)? onChanged;
  final String hintText;
  final T? value;
  final Color? color;
  final Color? borderColor;
  final double? fontSize;
  final double iconSize;
  final bool required;
  final bool showIconRemove;
  final bool isBorder;
  final String? Function(T?)? validate;
  final double radius;
  final Widget? icon;
  final TextStyle? style;
  final TextAlign? hintAlign;
  final EdgeInsets? contentPadding;
  final BorderRadius? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final DropdownButtonBuilder? selectedItemBuilder;
  const CustomDropDown({
    super.key,
    required this.items,
    this.onChanged,
    required this.hintText,
    this.value,
    this.color,
    this.fontSize,
    this.iconSize = 18,
    this.required = false,
    this.showIconRemove = true,
    this.isBorder = true,
    this.validate,
    this.borderColor,
    this.radius = 8,
    this.icon,
    this.style,
    this.hintAlign,
    this.contentPadding,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.selectedItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      value: value,
      decoration: InputDecoration(
        isDense: true,

        prefix: prefixIcon,
        suffix: suffixIcon,
        contentPadding: contentPadding ?? Dimensions.sp16.padingVer,
        border: !isBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? borderColor_2,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
              ),
        focusColor: AppColors.brand,
        focusedBorder: !isBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.brand),
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
              ),
        enabledBorder: !isBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? borderColor_2,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
              ),
        disabledBorder: !isBorder
            ? InputBorder.none
            : OutlineInputBorder(
                borderSide: BorderSide(
                  color: borderColor ?? borderColor_2,
                ),
                borderRadius: borderRadius ?? BorderRadius.circular(radius),
              ),
        // hintText: hintText,
        fillColor: color,
        filled: true,
      ),
      isExpanded: true,
      hint: Text(
        hintText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: hintAlign,
        style: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.input_placeholderDefault,
        ),
      ),
      style: style,
      items: items,
      validator: (value) {
        if (validate != null) {
          return validate?.call(value);
        }

        if (required && value == null) {
          return 'Vui lòng chọn';
        }
        return null;
      },
      onChanged: onChanged,
      onSaved: (value) {},
      buttonStyleData: ButtonStyleData(
        //height: 48,
        padding: Dimensions.sp12.padingRight,
      ),
      iconStyleData: IconStyleData(
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value != null && showIconRemove)
              IconButton(
                icon: const Icon(
                  Icons.clear,
                  color: AppColors.black,
                  size: 15,
                ),
                onPressed: () {
                  onChanged?.call(null);
                },
              ),
            icon ??
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.black,
                ),
          ],
        ),
        iconSize: iconSize,
      ),
      selectedItemBuilder: selectedItemBuilder,
      dropdownStyleData: const DropdownStyleData(
        padding: EdgeInsets.zero,
        scrollPadding: EdgeInsets.zero,
      ),
    );
  }
}
