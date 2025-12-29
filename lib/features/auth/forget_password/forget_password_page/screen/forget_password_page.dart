import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/core/common/widget/custom_text_field.dart';
import 'package:diaz1234567890/features/auth/forget_password/forget_password_page/controller/forget_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ForgetPasswordController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Forget Password",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 17.h),
                    Text(
                      "Please enter your email address to request a password reset",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    CustomTextField(
                      controller: controller.forgetPasswordController,
                      lebelText: "Email",
                      hintText: "Enter Your Email address",
                    ),

                    CustomButton(label: 'Login', onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
