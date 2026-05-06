import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/ai/screen/ai_chat_screen.dart';
import 'package:diaz1234567890/features/home/controller/home_page_controller.dart';
import 'package:diaz1234567890/features/home/screen/listing_page.dart';
import 'package:diaz1234567890/features/home/widget/filter_bottom_sheet.dart';
import 'package:diaz1234567890/features/home/widget/home_search_filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YachtHomePage extends StatelessWidget {
  YachtHomePage({super.key});

  final HomePageController homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  Imagepath.homeBoat,
                  height: 244,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  bottom: 15,
                  left: 20,
                  right: 20,
                  child: HomeSearchFilterBar(
                    controller: homePageController.searchTextController,
                    isLoading: homePageController.aiSearchController.isLoading,
                    onFilterTap: () {
                      Get.bottomSheet(
                        const FilterBottomSheet(
                          searchControllerTag: 'home_search',
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        homePageController.aiSearchController
                            .naturalLanguageSearch(value);
                      }
                    },
                    onAskAiTap: () => homePageController.handleAiSearch(
                      homePageController.searchTextController.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(
                    homePageController.listingController.tabs.length,
                    (index) {
                      final isSelected =
                          homePageController
                              .listingController
                              .selectedTab
                              .value ==
                          index;
                      return GestureDetector(
                        onTap: () => homePageController.listingController
                            .changeTab(index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.black
                                : const Color(0xFFF5FEFF),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            homePageController.listingController.tabs[index],
                            style: getTextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            YachtListingPage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AiChatScreen()),
        backgroundColor: Colors.white,
        icon: Image.asset(Iconpath.askAi, width: 18, height: 18),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Ask AI',
            style: getTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
