import 'package:diaz1234567890/features/auth/login_screen/screen/login_screen.dart';
import 'package:diaz1234567890/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:diaz1234567890/features/details/screen/details_screen.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step2.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step3.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step4.dart';
import 'package:diaz1234567890/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:diaz1234567890/features/profile/main/screen/profile_screen.dart';
import 'package:diaz1234567890/features/profile/my_listing/screen/my_listing_screen.dart';
import 'package:diaz1234567890/features/profile/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:diaz1234567890/features/notifications/screen/notification_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static String bottomNavBar = "/bottomNavBar";
  static String profileScreen = "/profileScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String privacyPolicyScreen = "/privacyPolicyScreen";
  static String myListingScreen = "/myListingScreen";
  static String detailsScreen = "/detailsScreen";
  static String packageScreenStep2 = "/packageScreenStep2";
  static String packageScreenStep3 = "/packageScreenStep3";
  static String packageScreenStep4 = "/packageScreenStep4";
  static String loginScreen = "/loginScreen";
  static String notificationsScreen = "/notifications";

  static String getBottomNavBar() => bottomNavBar;
  static String getProfileScreen() => profileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getPrivacyPolicyScreen() => privacyPolicyScreen;
  static String getMyListingScreen() => myListingScreen;
  static String getDetailsScreen() => detailsScreen;
  static String getPackageScreenStep2() => packageScreenStep2;
  static String getPackageScreenStep3() => packageScreenStep3;
  static String getPackageScreenStep4() => packageScreenStep4;
  static String getLoginScreen() => loginScreen;
  static String getNotificationsScreen() => notificationsScreen;

  // ...existing code...

  static List<GetPage> routes = [
    GetPage(name: bottomNavBar, page: () => BottomNavbarScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),
    GetPage(name: myListingScreen, page: () => MyListingScreen()),
    GetPage(name: notificationsScreen, page: () => NotificationScreen()),
    GetPage(name: detailsScreen, page: () => DetailsScreen()),
    GetPage(name: packageScreenStep2, page: () => PackageScreenStep2()),
    GetPage(name: packageScreenStep3, page: () => PackageScreenStep3()),
    GetPage(name: packageScreenStep4, page: () => PackageScreenStep4()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
  ];
}
