import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/features/auth/login_screen/screen/login_screen.dart';
import 'package:diaz1234567890/features/auth/login_screen/controller/login_controller.dart';
import 'package:diaz1234567890/features/profile/main/controller/profile_controller.dart';
import 'package:diaz1234567890/features/profile/main/widgets/settings_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());
    final LoginController loginController = Get.find<LoginController>();

    return Obx(() {
      if (loginController.isGuest.value) {
        return Scaffold(
          appBar: CustomAppBar(title: "Profile"),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Guest Mode",
                    style: getTextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "You are currently using a guest account.\n"
                    "Log in to access your profile, listings,\n"
                    "notifications, and personalized features.",
                    textAlign: TextAlign.center,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.offAll(() => LoginScreen());
                      },
                      icon: const Icon(Icons.login, size: 20),
                      label: Text(
                        "Log In",
                        style: getTextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C2C70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Continue as Guest",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // ── Authenticated User View (Original Profile) ─────────────────────
      return Scaffold(
        appBar: CustomAppBar(title: "Profile"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      Imagepath.user,
                      height: 68,
                      width: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Wade Warren",
                    style: getTextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Account & Settings",
                        style: getTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SettingsButton(
                    icon: Icons.person_outline_outlined,
                    title: 'Profile Info',
                    subtitle: 'Email, Phone',
                    onTap: () {
                      Get.toNamed('/editProfileScreen');
                    },
                  ),
                  SettingsButton(
                    icon: Icons.list,
                    title: 'My Listing',
                    subtitle: 'See All Publish Listing',
                    onTap: () {
                      Get.toNamed('/myListingScreen');
                    },
                  ),
                  SettingsButton(
                    icon: Icons.assignment_outlined,
                    title: 'Report',
                    subtitle: 'Generate Report',
                    onTap: () {},
                  ),
                  SettingsButton(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    subtitle: 'Enable Push Notification',
                    toggleValue: profileController.notificationToggle,
                    onToggle: profileController.toggleNotification,
                    onTap: () {},
                  ),
                  SettingsButton(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Data Protection Info',
                    onTap: () {
                      Get.toNamed('/privacyPolicyScreen');
                    },
                  ),
                  SettingsButton(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions',
                    subtitle: 'User agreement',
                    onTap: () {},
                  ),
                  SizedBox(height: 23),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.profileButtonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            Iconpath.headphoneLogo,
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Need Help?",
                                style: getTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                "Contact Support",
                                style: getTextStyle(
                                  color: AppColors.subTitle,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: AppColors.profileButtonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                Iconpath.accountUser,
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Account Management",
                                style: getTextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () {
                                  loginController.isGuest.value =
                                      true; // Optional: reset on logout
                                  Get.offAll(LoginScreen());
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 14),
                              IconButton(
                                onPressed: () {
                                  Get.snackbar(
                                    'Delete',
                                    'Account delete successfully',
                                  );
                                  Get.offAll(LoginScreen());
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                              Text(
                                'Delete Account',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
