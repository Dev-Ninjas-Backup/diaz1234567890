import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:diaz1234567890/features/home/screen/home.dart';
import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/profile/main/screen/profile_screen.dart';
import 'package:diaz1234567890/features/search/screen/search_screen.dart';
import 'package:diaz1234567890/features/sell/screen/sell_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  final List<Widget> screens = [
    YachtHomePage(),
    YachtSearchPage(),
    SellScreen(),
    ProfileScreen(),
  ];

  final List<String> activeIcons = [
    Iconpath.activeHome,
    Iconpath.activeSearch,
    Iconpath.activeSellYacht,
    Iconpath.activeProfile,
  ];

  final List<String> inactiveIcons = [
    Iconpath.inactiveHome,
    Iconpath.inactiveSearch,
    Iconpath.inactiveSellYacht,
    Iconpath.inactiveProfile,
  ];

  final List<String> labels = ['Home', 'Search', 'Sell', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(0, -3),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(40, 14, 40, 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                final isSelected = controller.selectedIndex.value == index;
                return GestureDetector(
                  onTap: () {
                    // If clicking on "Sell" button (index 2)
                    if (index == 2) {
                      if (StorageService.hasToken()) {
                        // If logged in, initialize controller and navigate to packageScreenStep2
                        Get.put(SellPackageController(), permanent: false);
                        Get.toNamed('/packageScreenStep2');
                      } else {
                        // If not logged in, show SellScreen
                        controller.changeIndex(index);
                      }
                    } else {
                      controller.changeIndex(index);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        isSelected ? activeIcons[index] : inactiveIcons[index],
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          color: isSelected
                              ? Color(0xFF004DAC)
                              : Color(0xFF6B95FF),
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
