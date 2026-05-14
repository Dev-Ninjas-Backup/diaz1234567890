import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/search/screen/search_listings.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:diaz1234567890/features/search/controller/yacht_search_page_controller.dart';
import 'package:diaz1234567890/features/search/widget/search_filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';

class YachtSearchPage extends StatelessWidget {
  const YachtSearchPage({super.key});

  static const String _controllerTag = 'search_main';
  static const String _pageControllerTag = 'search_main_page';

  @override
  Widget build(BuildContext context) {
    final listingController =
        Get.isRegistered<YachtSearchListingController>(tag: _controllerTag)
        ? Get.find<YachtSearchListingController>(tag: _controllerTag)
        : Get.put(YachtSearchListingController(), tag: _controllerTag);

    final pageController =
        Get.isRegistered<YachtSearchPageController>(tag: _pageControllerTag)
        ? Get.find<YachtSearchPageController>(tag: _pageControllerTag)
        : Get.put(
            YachtSearchPageController(listingControllerTag: _controllerTag),
            tag: _pageControllerTag,
          );

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  Imagepath.homeBoat,
                  height: 244,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),

                // Search Bar and Filter Button
                Positioned(
                  bottom: 15,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              const SearchFilterBottomSheet(
                                searchControllerTag: _controllerTag,
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                            );
                          },
                          child: Image.asset(
                            Iconpath.customTune,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: pageController.searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                listingController.naturalLanguageSearch(value);
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Find me a Viking for sale from 2005 to 2008",
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => TextButton(
                            onPressed: listingController.isLoading.value
                                ? null
                                : () => pageController.handleAiSearch(
                                    pageController.searchController.text,
                                  ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              foregroundColor: Colors.black,
                            ),
                            child: listingController.isLoading.value
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Image.asset(
                                        Iconpath.askAi,
                                        width: 18,
                                        height: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2,
                                        ),
                                        child: Text(
                                          "Ask AI",
                                          style: getTextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Obx(
            //   () => YachtFilterBar(
            //     models: controller.models.toList(),
            //     classes: controller.classes.toList(),
            //     onModelChanged: (value) =>
            //         controller.selectedModel.value = value,
            //     onClassChanged: (value) =>
            //         controller.selectedClass.value = value,
            //     onYearChanged: (value) => controller.selectedYear.value = value,
            //     onPriceChanged: (value) =>
            //         controller.selectedPrice.value = value,
            //   ),
            // ),
            YachtSearchListingPage(controllerTag: _controllerTag),

            SizedBox(height: 5),

            Center(
              child: Obx(
                () => TextButton(
                  onPressed:
                      listingController.isLoadingMore.value ||
                          !listingController.hasMore.value
                      ? null
                      : listingController.fetchNextPage,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF00A3AC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: listingController.isLoadingMore.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          listingController.hasMore.value
                              ? "Show More"
                              : "No more",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(Imagepath.homeBoat),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Premium Destinations",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Showcasing the finest yachts\nfrom our trusted network.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withValues(
                              alpha: 0.8,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          label: const Text(
                            "Discover More",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
