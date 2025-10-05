import 'package:diaz1234567890/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  // static String splashScreen = "/splashScreen";
  static String bottomNavBar = "/bottomNavBar";

  // static String getSplashScreen() => splashScreen;
  static String getBottomNavBar() => bottomNavBar;

  static List<GetPage> routes = [
    // GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: bottomNavBar, page: () => BottomNavbarScreen()),
  ];
}
