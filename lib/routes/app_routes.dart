import 'package:diaz1234567890/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:diaz1234567890/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:diaz1234567890/features/profile/main/screen/profile_screen.dart';
import 'package:diaz1234567890/features/profile/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static String bottomNavBar = "/bottomNavBar";
  static String profileScreen = "/profileScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String privacyPolicyScreen = "/privacyPolicyScreen";

  static String getBottomNavBar() => bottomNavBar;
  static String getProfileScreen() => profileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getPrivacyPolicyScreen() => privacyPolicyScreen;

  static List<GetPage> routes = [
    GetPage(name: bottomNavBar, page: () => BottomNavbarScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),
  ];
}
