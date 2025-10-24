part of 'init_app_style.dart';

abstract class AppStyle {
  static const FontWeight _LIGHT = FontWeight.w300;
  static const FontWeight _DEFAULT = FontWeight.w400;
  static const FontWeight _MEDIUM = FontWeight.w500;
  static const FontWeight _SEMIBOLD = FontWeight.w600;
  static const FontWeight _BOLD = FontWeight.w700;

  static TextStyle headingDisplay = const TextStyle(
    fontSize: 32,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle heading3xl = const TextStyle(
    fontSize: 28,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle heading2xl = const TextStyle(
    fontSize: 24,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingXl = const TextStyle(
    fontSize: 20,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingLg = const TextStyle(
    fontSize: 18,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingMd = const TextStyle(
    fontSize: 16,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle headingBs = const TextStyle(
    fontSize: 14,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdRegular = const TextStyle(
    fontSize: 16,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdMedium = const TextStyle(
    fontSize: 16,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdSemiBold = const TextStyle(
    fontSize: 16,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyMdBold = const TextStyle(
    fontSize: 16,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsRegular = const TextStyle(
    fontSize: 14,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsMedium = const TextStyle(
    fontSize: 14,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsSemiBold = const TextStyle(
    fontSize: 14,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyBsBold = const TextStyle(
    fontSize: 14,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmRegular = const TextStyle(
    fontSize: 12,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmMedium = const TextStyle(
    fontSize: 12,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmSemiBold = const TextStyle(
    fontSize: 12,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodySmBold = const TextStyle(
    fontSize: 12,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsRegular = const TextStyle(
    fontSize: 10,
    fontWeight: _DEFAULT,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsMedium = const TextStyle(
    fontSize: 10,
    fontWeight: _MEDIUM,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsSemiBold = const TextStyle(
    fontSize: 10,
    fontWeight: _SEMIBOLD,
    color: AppColors.text_primary,
  );

  static TextStyle bodyXsBold = const TextStyle(
    fontSize: 10,
    fontWeight: _BOLD,
    color: AppColors.text_primary,
  );

  static TextStyle light({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _LIGHT,
      decoration: decoration,
    );
  }

  static TextStyle normal({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _DEFAULT,
      decoration: decoration,
    );
  }

  static TextStyle medium({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _MEDIUM,
      decoration: decoration,
    );
  }

  static TextStyle semibold({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _SEMIBOLD,
      decoration: decoration,
    );
  }

  static TextStyle bold({
    double fontSize = 14,
    Color? color,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color ?? AppColors.text_primary,
      fontWeight: _BOLD,
      decoration: decoration,
    );
  }
}
