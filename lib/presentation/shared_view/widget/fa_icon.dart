import 'package:flutter/widgets.dart';
import 'package:one_click/presentation/config/app_style/init_app_style.dart';

enum FaType {
  thin(FontWeight.w100),
  light(FontWeight.w300),
  regular(FontWeight.w400),
  solid(FontWeight.w900);

  final FontWeight weight;

  const FaType(this.weight);
}

enum FaStyle {
  classic('FaClassic'),
  pro('FaPro'),
  brand('FaBrand'),
  duotone('FaDoutone'),
  sharp('FaSharp');

  final String style;

  const FaStyle(this.style);
}

Widget FaIcon({
  required String code,
  Color? color,
  double size = 16,
  FaType type = FaType.regular,
  FaStyle style = FaStyle.pro,
  String? fontFamily,
}) {
  return Text(
    String.fromCharCode(int.parse(code, radix: 16)),
    style: TextStyle(
      fontFamily: fontFamily ?? style.style,
      color: color ?? AppColors.grey79,
      fontSize: size,
      fontWeight: type.weight,
    ),
    textAlign: TextAlign.center,
  );
}
