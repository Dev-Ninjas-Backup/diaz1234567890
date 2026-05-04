import 'package:diaz1234567890/features/auth/login_screen/screen/login_screen.dart';
import 'package:diaz1234567890/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:diaz1234567890/features/details/screen/details_screen.dart';
import 'package:diaz1234567890/features/faq/screen/faq_screen.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step1.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step2.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step3.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step4.dart';
import 'package:diaz1234567890/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:diaz1234567890/features/profile/main/screen/profile_screen.dart';
import 'package:diaz1234567890/features/profile/my_listing/screen/my_listing_screen.dart';
import 'package:diaz1234567890/features/profile/privacy_policy/screen/privacy_policy_screen.dart';
import 'package:diaz1234567890/features/notifications/screen/notification_screen.dart';
import 'package:diaz1234567890/features/sell/screen/sell_screen.dart';
import 'package:diaz1234567890/features/terms_and_condition/screen/terms_and_condition_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static String bottomNavBar = "/bottomNavBar";
  static String profileScreen = "/profileScreen";
  static String editProfileScreen = "/editProfileScreen";
  static String privacyPolicyScreen = "/privacyPolicyScreen";
  static String myListingScreen = "/myListingScreen";
  static String detailsScreen = "/detailsScreen";
  static String packageScreenStep1 = "/packageScreenStep1";
  static String packageScreenStep2 = "/packageScreenStep2";
  static String sellPackageScreen = "/sellPackageScreen";
  static String packageScreenStep4 = "/packageScreenStep4";
  static String loginScreen = "/loginScreen";
  static String notificationsScreen = "/notifications";
  static String sellScreen = "/sellScreen";
  static String termsConditionScreen = "/termsConditionScreen";
  static String faqScreen = "/faqScreen";




  static String getBottomNavBar() => bottomNavBar;
  static String getProfileScreen() => profileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getPrivacyPolicyScreen() => privacyPolicyScreen;
  static String getMyListingScreen() => myListingScreen;
  static String getDetailsScreen() => detailsScreen;
  static String getPackageScreenStep1() => packageScreenStep1;
  static String getPackageScreenStep2() => packageScreenStep2;
  static String getSellPackageScreen() => sellPackageScreen;
  static String getPackageScreenStep4() => packageScreenStep4;
  static String getLoginScreen() => loginScreen;
  static String getNotificationsScreen() => notificationsScreen;
  static String getSellScreen() => sellScreen;
  static String getTermsConditionScreen() => termsConditionScreen;
  static String getFaqScreen() => faqScreen;
  // ...existing code...

  

  static List<GetPage> routes = [
    GetPage(name: bottomNavBar, page: () => BottomNavbarScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
    GetPage(name: privacyPolicyScreen, page: () => PrivacyPolicyScreen()),
    GetPage(name: myListingScreen, page: () => MyListingScreen()),
    GetPage(name: notificationsScreen, page: () => NotificationScreen()),
    GetPage(name: detailsScreen, page: () => DetailsScreen()),
    GetPage(name: packageScreenStep1, page: () => PackageScreenStep1()),
    GetPage(name: packageScreenStep2, page: () => PackageScreenStep2()),
    GetPage(name: sellPackageScreen, page: () => SellPackageScreen()),
    GetPage(name: packageScreenStep4, page: () => PackageScreenStep4()),
    GetPage(name: loginScreen, page: () => LoginScreen()),
    GetPage(name: sellScreen, page: () => SellScreen()),
    GetPage(name: termsConditionScreen, page: () => TermsConditionScreen()),
    GetPage(name: faqScreen, page: () => FaqScreen()),
  ];
}
