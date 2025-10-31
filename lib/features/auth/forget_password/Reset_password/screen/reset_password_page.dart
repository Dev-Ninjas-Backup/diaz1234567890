import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/core/common/widget/custom_text_field.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/features/auth/forget_password/Reset_password/controller/reset_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ResetPasswordController());
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Set new password",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 17.h),
                  Text(
                    "Please enter your new password and confirm password",
                    style: TextStyle(),
                  ),

                  SizedBox(height: 30.h),
                  Obx(
                    () => CustomTextField(
                      controller: controller.resetPasswordController,
                      lebelText: "Password",
                      hintText: "Enter Your Password",

                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.toggleVisibleObsecurePassword();
                        },
                        child: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.appPrimaryColor,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),

                  Obx(
                    () => CustomTextField(
                      controller: controller.resetConfirmPasswordController,
                      lebelText: "Confirm Password",
                      hintText: "Enter Your Confirm Password",
                      obscureText: controller.isConfirmPasswordHidden.value,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          controller.toggleVisibleObsecureConfirmPassword();
                        },
                        child: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.appPrimaryColor,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),
                  CustomButton(label: 'Reset Password', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
