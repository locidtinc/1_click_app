import 'package:base_mykiot/base_lhe.dart';
import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    Key? key,
    required this.title,
    this.height = kToolbarHeight,
    this.bottom,
    this.actions,
    this.leading,
  }) : super(key: key);

  final String title;
  final double height;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: whiteColor,
      centerTitle: true,
      title: Text(
        title,
        style: p3.copyWith(color: blackColor),
      ),
      iconTheme: const IconThemeData(color: blackColor),
      actions: actions ?? [],
      bottom: bottom,
      leading: leading,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
