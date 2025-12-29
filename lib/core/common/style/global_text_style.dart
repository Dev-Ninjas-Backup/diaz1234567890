import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w600,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.appPrimaryColor,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
  );
}

TextStyle getBodyTextStyle({
  double fontSize = 14.0,
  FontWeight fontWeight = FontWeight.w400,
  TextAlign textAlign = TextAlign.center,
  Color color = AppColors.appBodyColor,
}) {
  return GoogleFonts.inter(
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    color: color,
  );
}
