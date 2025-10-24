import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:one_click/shared/ext/index.dart';

import '../../../presentation/config/app_style/init_app_style.dart';

Widget ChipCustom({
  required Color color,
  required String title,
  EdgeInsets? padding,
  Function()? onTap,
  bool isActive = false,
  Widget? suffixIcon,
  Widget? perfixIcon,
  TextStyle? titleStyle,
  bool isBorder = true,
  BorderRadius? borderRadius,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: onTap != null ? 3.pading : 0.pading,
      decoration: onTap != null
          ? BoxDecoration(
              borderRadius: 30.radius,
              border: Border.all(
                color: isActive ? color : Colors.transparent,
              ),
            )
          : null,
      child: Container(
        padding: padding ?? (6.padingHor + 2.5.padingVer),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: isBorder
              ? Border.all(
                  color: color.withOpacity(0.2),
                )
              : null,
          borderRadius: borderRadius ?? 20.radius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (perfixIcon != null) perfixIcon,
            if (perfixIcon != null) 4.width,
            Text(
              title,
              style: titleStyle?.copyWith(color: color) ??
                  AppStyle.bodyXsBold.copyWith(
                    color: color,
                  ),
            ).flexible(),
            if (suffixIcon != null) suffixIcon,
          ],
        ),
      ),
    ),
  );
}

Widget ChipDashBorder({
  required Color color,
  required String title,
  TextStyle? titleStyle,
  EdgeInsets? padding,
  Function()? onTap,
  bool isActive = false,
  Widget? suffixIcon,
  Widget? perfixIcon,
  Radius? radius,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: onTap != null ? 3.pading : 0.pading,
      decoration: onTap != null
          ? BoxDecoration(
              borderRadius: 30.radius,
              border: Border.all(
                color: isActive ? color : Colors.transparent,
              ),
            )
          : null,
      child: DottedBorder(
        color: color.withOpacity(0.2),
        strokeWidth: 1,
        radius: radius ?? const Radius.circular(20),
        borderType: BorderType.RRect,
        borderPadding: 0.pading,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: padding ?? (6.padingHor + 1.2.padingVer),
            decoration: BoxDecoration(
              borderRadius: 20.radius,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (perfixIcon != null) perfixIcon,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: titleStyle?.copyWith(color: color) ??
                      AppStyle.bodyXsBold.copyWith(
                        color: color,
                      ),
                ).flexible(),
                if (suffixIcon != null) suffixIcon,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget ChipBadgeCustom({
  required Color color,
  required String title,
  EdgeInsets? padding,
  Widget? icon,
  Color? bgColor,
}) {
  return Container(
    padding: padding ?? (6.padingHor + 2.5.padingVer),
    decoration: BoxDecoration(
      color: bgColor ?? AppColors.bg_primary,
      borderRadius: 20.radius,
      boxShadow: AppShadows.elevator0 + AppShadows.elevator0,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon ??
            Icon(
              Icons.circle,
              color: color,
              size: 6,
            ),
        4.width,
        Text(
          title,
          style: AppStyle.bodyXsBold.copyWith(
            color: color,
          ),
        ).flexible(),
      ],
    ),
  );
}
