import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/features/auth/sign_up/signup_page/controller/signup_controller.dart';
import 'package:diaz1234567890/features/auth/sign_up/verification_signup/screen/verification_signup_page.dart';
import 'package:diaz1234567890/features/auth/splash_login/login_screen/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/common/widget/custom_text_field.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Center(
                child: Text(
                  "Sign Up",
                  style: getTextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    CustomTextField(
                      //validator:
                      controller: controller.nameController,
                      lebelText: 'Username',
                      hintText: 'Full name',
                      suffixIcon: Icon(Icons.person),
                    ),

                    CustomTextField(
                      //validator:
                      controller: controller.emailController,
                      lebelText: 'Email',
                      hintText: 'example@gmail.com',
                      suffixIcon: Icon(Icons.email),
                    ),

                    Obx(
                      () => CustomTextField(
                        //validator:
                        controller: controller.passwordController,
                        lebelText: 'Password',
                        hintText: 'Enter Your Password',
                        obscureText: controller.isPasswordHidden.value,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.toggleVisibleObsecurePassword();
                          },

                          child: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 18.sp,
                            color: AppColors.appPrimaryColor,
                          ),
                        ),
                      ),
                    ),

                    Obx(
                      () => CustomTextField(
                        //validator:
                        controller: controller.confirmPasswordController,
                        lebelText: 'Confirm Password',
                        hintText: 'Enter Your Confirm Password',
                        obscureText: controller.isConfirmPasswordHidden.value,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            controller.toggleVisibleObsecureConfirmPassword();
                          },
                          child: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 18.sp,
                            color: AppColors.appPrimaryColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    CustomButton(
                      label: 'Sign Up',
                      onPressed: () {
                        Get.to(VerificationSignUpPage());
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 80.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: getBodyTextStyle(),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              Get.to(LoginScreen());
                            },

                            child: Text(
                              "Log in",
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
