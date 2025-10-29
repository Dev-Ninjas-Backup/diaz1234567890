import 'package:diaz1234567890/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:diaz1234567890/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:diaz1234567890/features/profile/main/screen/profile_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static String bottomNavBar = "/bottomNavBar";
  static String profileScreen = "/profileScreen";
  static String editProfileScreen = "/editProfileScreen";

  static String getBottomNavBar() => bottomNavBar;
  static String getProfileScreen() => profileScreen;
  static String getEditProfileScreen() => editProfileScreen;

  static List<GetPage> routes = [
    GetPage(name: bottomNavBar, page: () => BottomNavbarScreen()),
    GetPage(name: profileScreen, page: () => ProfileScreen()),
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),
  ];
}
