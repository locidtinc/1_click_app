import 'package:flutter/material.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';
import 'package:one_click/shared/ext/index.dart';

class BaseBottomBar extends StatelessWidget {
  const BaseBottomBar({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final paddingBottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: 16.padingHor + 16.padingTop + (paddingBottom / 2).padingBottom,
      child: child,
    );
  }
}
