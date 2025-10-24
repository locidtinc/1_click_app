import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/shared/ext/index.dart';

Widget IconBtn({
  required Widget icon,
  Function()? onTap,
  Size? size,
  Color? iconColor,
  Color? backgroundColor,
  BorderRadius? borderRadius,
  int count = 0,
  EdgeInsets? padding,
  List<BoxShadow>? boxShadow,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Badge.count(
      count: count,
      backgroundColor: AppColors.red50,
      isLabelVisible: count > 0,
      textStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 11,
      ),
      child: Container(
        padding: padding ?? 8.pading,
        height: size?.height ?? 40,
        width: size?.width ?? 40,
        decoration: BoxDecoration(
          color: backgroundColor ??
              AppColors.button_neutral_alpha_backgroundDefault,
          borderRadius: borderRadius ?? 50.radius,
          boxShadow: boxShadow,
        ),
        child: Center(
          child: icon,
        ),
      ),
    ),
  );
}
