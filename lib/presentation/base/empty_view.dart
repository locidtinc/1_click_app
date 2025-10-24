import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_click/presentation/base/label_button.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

Widget EmptyComfirm({
  String? labelBtn,
  required String text,
  Function()? onPressed,
  IconData? svgAsset,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Widget? icon,
  Color? btnColor,
  Widget? imgEmpty,
}) {
  return Center(
    child: Column(
      children: [
        imgEmpty ??
            IconSpecial(
              fallbackIcon: svgAsset ?? Icons.search_off,
              colorIcon: AppColors.fg_tertiary,
            ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: AppStyle.bodyMdRegular.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        if (onPressed != null) ...[
          16.height,
          LabelButton(
            onPressed: onPressed,
            label: labelBtn ?? 'Thêm mới',
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            backgroundColor: btnColor ?? AppColors.brand,
          ),
        ],
      ],
    ).container(padding: 32.padingVer + 16.padingHor),
  );
}

Widget EmptySearch({
  String? text,
  IconData? iconData,
  Color? iconColor,
}) {
  return Column(
    children: [
      Icon(
        iconData ?? Icons.search_off,
        size: 48,
        color: iconColor ?? AppColors.text_tertiary,
      ),
      16.height,
      Text(
        text ?? 'Không tìm thấy kết quả',
        textAlign: TextAlign.center,
        style: AppStyle.headingLg,
      ),
    ],
  ).container(padding: 32.padingVer + 16.padingHor);
}

Widget IconSpecial({
  Widget? icon,
  Color? color,
  Color? colorIcon,
  IconData fallbackIcon = Icons.info_outline, // icon mặc định
}) {
  return Container(
    padding: 8.pading,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: (color ?? AppColors.border_primary).withOpacity(0.05),
      ),
    ),
    child: Container(
      padding: 8.pading,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: (color ?? AppColors.border_primary).withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Container(
        padding: 12.pading,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (color ?? AppColors.fg_tertiary).withOpacity(0.15),
        ),
        child: icon ??
            Icon(
              fallbackIcon,
              size: 32,
              color: colorIcon ?? AppColors.fg_tertiary,
            ),
      ),
    ),
  );
}
