import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/shared/ext/index.dart';

Widget CustomBtn({
  required String? title,
  Function()? onPressed,
  Function()? onLongPress,
  Widget? prefix,
  Widget? suffix,
  Color? backgroundColor,
  double radius = 8,
  BorderSide side = BorderSide.none,
  EdgeInsets? padding,
  TextStyle? textStyle,
  Size? fixedSize,
}) {
  return TextButton(
    onPressed: onPressed,
    onLongPress: onLongPress,
    style: TextButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
      shape: RoundedRectangleBorder(
        borderRadius: radius.radius,
        side: side,
      ),
      fixedSize: fixedSize,
    ),
    child: RichText(
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          if (prefix != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: prefix,
            ),
          if (title != null)
            TextSpan(
              text: title,
              style: textStyle ?? AppStyle.bodyMdSemiBold,
            ),
          if (suffix != null)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: suffix,
            ),
        ],
      ),
    ),
  );
}
