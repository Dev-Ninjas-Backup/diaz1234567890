import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/ai/controller/ai_search_controller.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiSearchResultsScreen extends StatelessWidget {
  final String query;
  final List<Yacht> results;

  const AiSearchResultsScreen({
    super.key,
    required this.query,
    required this.results,
  });

  static Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value.substring(0, value.length > 10 ? 10 : value.length),
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AiSearchController(initialQuery: query, initialResults: results),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Stack Section (Search Bar)
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: controller.toggleLimitSlider,
                          child: Image.asset(
                            Iconpath.customTune,
                            width: 25,
                            height: 25,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: controller.searchController,
                            onSubmitted: controller.handleAiSearch,
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
                                : () => controller.handleAiSearch(
                                    controller.searchController.text,
                                  ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
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
                            child: controller.isLoading.value
                                ? const SizedBox(
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
                                      const SizedBox(width: 6),
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
            Obx(
              () => controller.showLimitSlider.value
                  ? Padding(
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
                              value: controller.limit.value,
                              min: 0,
                              max: 100,
                              divisions: 100,
                              activeColor: const Color(0xFF00A3AC),
                              label: controller.limit.value.toInt().toString(),
                              onChanged: controller.setLimit,
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            child: Text(
                              controller.limit.value.toInt().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // Results Header
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '${controller.results.length} found',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Results List
            Obx(
              () => controller.results.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 16),
                          Text(
                            'No results found',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.results.length,
                        itemBuilder: (context, index) {
                          final yacht = controller.results[index];
                          return GestureDetector(
                            onTap: () => controller.navigateToDetails(yacht.id),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      yacht.image,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              Imagepath.singleBoat,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            yacht.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 12,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 2),
                                              Expanded(
                                                child: Text(
                                                  yacht.location,
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.grey[600],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildDetail("Make", yacht.make),
                                              _buildDetail("Year", yacht.year),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "Price: ${yacht.price}",
                                            style: const TextStyle(
                                              color: Color(0xFF00A3AC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
