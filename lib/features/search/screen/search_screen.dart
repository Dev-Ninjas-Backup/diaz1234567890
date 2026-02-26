import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/search/screen/search_listings.dart';
import 'package:diaz1234567890/features/search/widget/filter_bar.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:diaz1234567890/features/ai/screen/ai_search_results_screen.dart';
import 'package:diaz1234567890/core/services/api_service.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';

class YachtSearchPage extends StatefulWidget {
  const YachtSearchPage({super.key});

  @override
  State<YachtSearchPage> createState() => _YachtSearchPageState();
}

class _YachtSearchPageState extends State<YachtSearchPage> {
  late TextEditingController _searchController;
  late YachtSearchListingController controller;
  double _limit = 10;
  bool _showLimitSlider = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    controller = Get.put(YachtSearchListingController());
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
      controller.isLoading.value = true;

      await StorageService.init();
      final userId = StorageService.userId;

      if (userId == null || userId.isEmpty) {
        EasyLoading.showError('User not logged in');
        return;
      }

      final response = await ApiService.aiSearch(
        userId: userId,
        query: query,
        limit: _limit.toInt(),
      );

      if (response['error'] != null) {
        EasyLoading.showError(response['error'] ?? 'Search failed');
        return;
      }

      final data = response['data'] as List<dynamic>? ?? [];
      final yachts = <Yacht>[];

      for (final item in data) {
        try {
          final map = item as Map<String, dynamic>;
          String coverImageUrl = Imagepath.singleBoat;
          final images = map['images'];
          if (images is Map<String, dynamic> && images['Uri'] != null) {
            coverImageUrl = images['Uri'] as String;
          }
          final location = map['location'] as Map<String, dynamic>? ?? {};
          yachts.add(
            Yacht(
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
            ),
          );
        } catch (e) {
          print('Error parsing result: $e');
        }
      }

      Get.to(() => AiSearchResultsScreen(query: query, results: yachts));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('AI Search Error: $e');
    } finally {
      controller.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5FEFF),
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
                                controller.naturalLanguageSearch(value);
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
                            onPressed: controller.isLoading.value
                                ? null
                                : () => _handleAiSearch(_searchController.text),
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
                            child: controller.isLoading.value
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
              () => YachtFilterBar(
                models: controller.models.toList(),
                classes: controller.classes.toList(),
                onModelChanged: (value) =>
                    controller.selectedModel.value = value,
                onClassChanged: (value) =>
                    controller.selectedClass.value = value,
                onYearChanged: (value) => controller.selectedYear.value = value,
                onPriceChanged: (value) =>
                    controller.selectedPrice.value = value,
              ),
            ),
            YachtSearchListingPage(),

            SizedBox(height: 5),

            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF00A3AC),
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Show More",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.35),
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
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            // ignore: deprecated_member_use
                            backgroundColor: Colors.black.withOpacity(0.8),
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
