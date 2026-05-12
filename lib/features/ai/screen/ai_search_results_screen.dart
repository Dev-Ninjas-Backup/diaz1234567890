import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/ai/controller/ai_search_controller.dart';
import 'package:diaz1234567890/features/home/model/home_model.dart';
import 'package:diaz1234567890/features/home/widget/sell_banner_section.dart';
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

  static Widget _buildDetailCard(String label, String value) {
    final safeValue = value.isEmpty ? 'N/A' : value;
    final shortValue = safeValue.substring(
      0,
      safeValue.length > 10 ? 10 : safeValue.length,
    );
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 3),
          Text(
            shortValue,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
            Stack(
              children: [
                Image.asset(
                  Imagepath.homeBoat,
                  height: 244,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: SafeArea(
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      radius: 18,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ),
                ),
              ],
            ),

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
                  : SizedBox(
                      height: 340,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(left: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.results.length,
                        itemBuilder: (context, index) {
                          final yacht = controller.results[index];
                          return GestureDetector(
                            onTap: () => controller.navigateToDetails(yacht.id),
                            child: Container(
                              width: 230,
                              margin: const EdgeInsets.only(
                                right: 12,
                                bottom: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image on top
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      yacht.image,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              height: 150,
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
                                            return Container(
                                              height: 150,
                                              width: double.infinity,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: Colors.grey,
                                              ),
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
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                yacht.location,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            yacht.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          const Divider(height: 8),
                                          Row(
                                            children: [
                                              _buildDetailCard(
                                                "Make",
                                                yacht.make,
                                              ),
                                              _buildDetailCard(
                                                "Model",
                                                yacht.model,
                                              ),
                                              _buildDetailCard(
                                                "Year",
                                                yacht.year,
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          const Spacer(),
                                          Text(
                                            "Price: ${yacht.price}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Color(0xFF00A3AC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
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

            Center(
              child: Obx(
                () => controller.isFromFilters.value
                    ? GestureDetector(
                        onTap: () async {
                          await controller.fetchMoreResults(
                            controller.limit.value.toInt(),
                          );
                        },
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.appPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: controller.isLoadingMore.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Show more (${controller.results.length}/${controller.totalResults.value})',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ).copyWith(color: Colors.white),
                                  ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _showLimitSliderModal(context, controller);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00A3AC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Obx(
                            () => controller.isLoadingMore.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Show more',
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ).copyWith(color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            // Banner Section
            const SellBannerSection(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

void _showLimitSliderModal(
  BuildContext context,
  AiSearchController controller,
) {
  final sliderValue = 10.0.obs;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Number of Results',
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ).copyWith(color: Colors.black),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Column(
                children: [
                  Slider(
                    value: sliderValue.value,
                    min: 10,
                    max: 100,
                    divisions: 9,
                    activeColor: AppColors.appPrimaryColor,
                    inactiveColor: Colors.grey.shade300,
                    label: sliderValue.value.toStringAsFixed(0),
                    onChanged: (value) {
                      sliderValue.value = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Limit: ${sliderValue.value.toStringAsFixed(0)}',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ).copyWith(color: AppColors.appPrimaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Cancel',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ).copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.back();
                      await controller.fetchMoreResults(
                        sliderValue.value.toInt(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.appPrimaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
