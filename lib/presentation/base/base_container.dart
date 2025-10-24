import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';

class BaseContainerV2 extends StatelessWidget {
  const BaseContainerV2({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.color,
    this.borderColor,
    this.margin,
    this.border,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? borderColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: border ??
            Border.all(color: borderColor ?? AppColors.grey30, width: 1),
        color: color ?? AppColors.white,
      ),
      child: child,
    );
  }
}
