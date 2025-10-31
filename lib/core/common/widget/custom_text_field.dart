import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/global_text_style.dart';

class CustomTextField extends StatelessWidget {
  final String lebelText;
  final String hintText;
  final bool obscureText;
  final int? maxLine;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextEditingController controller;

  const CustomTextField({
    required this.controller,
    required this.lebelText,
    this.suffixIcon,
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lebelText, style: getTextStyle()),

          Container(
            margin: EdgeInsets.symmetric(vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.appSecondaryColor,
              borderRadius: BorderRadius.circular(12.r),

              border: Border.all(color: AppColors.appBorderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    obscureText: obscureText,
                    // maxLines: maxLine,
                    maxLines: obscureText ? 1 : null,
                    validator: validator,
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
                if (suffixIcon != null) suffixIcon!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
