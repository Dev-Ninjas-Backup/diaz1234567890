// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/home/controller/yacht_listing_controller.dart';
import 'package:diaz1234567890/features/home/screen/listing_page.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:diaz1234567890/features/ai/screen/ai_search_results_screen.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/features/ai/screen/ai_chat_screen.dart';

class YachtHomePage extends StatefulWidget {
  const YachtHomePage({super.key});

  @override
  State<YachtHomePage> createState() => _YachtHomePageState();
}

class _YachtHomePageState extends State<YachtHomePage> {
  late TextEditingController _searchController;
  late YachtListingController _homeController;
  late YachtSearchListingController _searchController_;
  double _limit = 10;
  bool _showLimitSlider = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _homeController = Get.put(YachtListingController());
    _searchController_ = Get.put(
      YachtSearchListingController(),
      tag: 'home_search',
    );
    // Set FLORIDA as default site
    _homeController.selectedFeaturedSite.value = 'FLORIDA';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleAiSearch(String query) async {
    if (query.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a search query',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      _searchController_.isLoading.value = true;

      // Get user ID from storage
      await StorageService.init();
      final userId = StorageService.userId;

      if (userId == null || userId.isEmpty) {
        EasyLoading.showError('User not logged in');
        return;
      }

      // Call AI search API
      final response = await ApiService.aiSearch(
        //userId: userId,
        query: query,
        limit: _limit.toInt(),
      );

      if (response['error'] != null) {
        EasyLoading.showError(response['error'] ?? 'Search failed');
        return;
      }

      // Parse results into Yacht objects
      final data = response['data'] as List<dynamic>? ?? [];
      final yachts = <Yacht>[];

      for (final item in data) {
        try {
          final map = item as Map<String, dynamic>;

          // Get image URL
          String coverImageUrl = Imagepath.singleBoat;
          final images = map['images'];
          if (images is Map<String, dynamic> && images['Uri'] != null) {
            coverImageUrl = images['Uri'] as String;
          }

          final location = map['location'] as Map<String, dynamic>? ?? {};
          final yacht = Yacht(
            id: map['document_id']?.toString() ?? '',
            title: '${map['make'] ?? ''} ${map['model'] ?? ''}'.trim(),
            location:
                '${location['BoatCityName'] ?? ''}, ${location['BoatStateCode'] ?? ''}',
            make: map['make']?.toString() ?? 'N/A',
            model: map['model']?.toString() ?? 'N/A',
            year: map['model_year']?.toString() ?? 'N/A',
            price: map['price'] != null
                ? '\$${(map['price'] as num).toStringAsFixed(0)}'
                : 'Call for Price',
            image: coverImageUrl,
          );
          yachts.add(yacht);
        } catch (e) {
          print('Error parsing result: $e');
        }
      }

      // Navigate to results screen
      Get.to(() => AiSearchResultsScreen(query: query, results: yachts));
    } catch (e) {
      EasyLoading.showError('Search failed: $e');
      print('AI Search Error: $e');
    } finally {
      _searchController_.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5FEFF),
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
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(
                            () => _showLimitSlider = !_showLimitSlider,
                          ),
                          child: Image.asset(
                            Iconpath.customTune,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                _searchController_.naturalLanguageSearch(value);
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
                            onPressed: () =>
                                _handleAiSearch(_searchController.text),
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
                              elevation: 0,
                            ),
                            child: _searchController_.isLoading.value
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
                                        padding: const EdgeInsets.symmetric(
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

            // Limit Slider
            if (_showLimitSlider)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Limit:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _limit,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        activeColor: const Color(0xFF00A3AC),
                        label: _limit.toInt().toString(),
                        onChanged: (value) => setState(() => _limit = value),
                      ),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        _limit.toInt().toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            Obx(
              () => Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: List.generate(_homeController.tabs.length, (
                        index,
                      ) {
                        bool isSelected =
                            _homeController.selectedTab.value == index;
                        return GestureDetector(
                          onTap: () => _homeController.changeTab(index),
                          child: Container(
                            margin: EdgeInsets.only(right: 12),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.black
                                  : Color(0xFFF5FEFF),
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _homeController.tabs[index],
                              style: getTextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            YachtListingPage(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // open the AI chat screen
          Get.to(() => const AiChatScreen());
        },
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
