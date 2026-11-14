import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  static TextStyle display({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle headline({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle title({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle subtitle({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    height: 1.4,
  );

  static TextStyle body({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: color ?? (dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    height: 1.5,
  );

  static TextStyle bodyMedium({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
    height: 1.5,
  );

  static TextStyle label({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: color ?? (dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    height: 1.4,
  );

  static TextStyle caption({Color? color, bool dark = false}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? (dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
    height: 1.4,
  );

  static TextStyle button({Color? color}) => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.white,
    letterSpacing: 0.1,
  );
}
