import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/features/auth/sign_up/verification_signup/controller/verification_signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerificationSignUpPage extends StatelessWidget {
  const VerificationSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationSignupController());

    final defaultPinTheme = PinTheme(
      width: 55.w,
      height: 55.w,
      textStyle: getTextStyle(),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.appBorderColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    final prefilled = Center(child: Text("-", style: getTextStyle()));

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 46.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verification",
                    style: getTextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 19.h),
                  Text(
                    "We've send you the verification code on xyz@gamail.com",
                    style: getBodyTextStyle(),
                  ),
                  SizedBox(height: 30.h),

                  Center(
                    child: Pinput(
                      mainAxisAlignment: MainAxisAlignment.center,
                      length: 4,
                      controller: controller.pinController,
                      defaultPinTheme: defaultPinTheme,
                      preFilledWidget: prefilled,
                      showCursor: true,
                      onCompleted: controller.onCompleted,
                      separatorBuilder: (index) => SizedBox(width: 23.w),
                    ),
                  ),
                  SizedBox(height: 21.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),

                    child: CustomButton(
                      label: "Verify",
                      onPressed: () {
                        if (!controller.isVerifying.value) {
                          controller.verifyOtp();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Re-send code in", style: getBodyTextStyle()),
                      SizedBox(width: 6.w),
                      Text(
                        "0:20",
                        style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.remindColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
