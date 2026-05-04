import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/home/controller/filter_controller.dart';
import 'package:diaz1234567890/features/search/controller/yacht_controller.dart';
import 'package:diaz1234567890/features/search/model/yacht_model.dart';
import 'package:diaz1234567890/features/details/screen/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeFilteredListingsPage extends StatelessWidget {
  const HomeFilteredListingsPage({super.key, required this.searchControllerTag});

  final String searchControllerTag;

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<YachtSearchListingController>(tag: searchControllerTag);
    final filterTag = 'home_filter_$searchControllerTag';
    final filterController = Get.isRegistered<FilterController>(tag: filterTag)
        ? Get.find<FilterController>(tag: filterTag)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image section (matches the design style you shared)
            Container(
              width: double.infinity,
              height: 244,
              decoration: ShapeDecoration(
                color: Colors.black.withValues(alpha: 0.40),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                image: const DecorationImage(
                  image: AssetImage(Imagepath.homeBoat),
                  fit: BoxFit.cover,
                ),
              ),
              child: const SizedBox(),
            ),

            // Results section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(
                () {
                  final yachts = controller.similarYachts;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${yachts.length} similar listing',
                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Filtered search results',
                        style: getBodyTextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (controller.isLoading.value)
                        const Center(child: CircularProgressIndicator())
                      else if (yachts.isEmpty)
                        Center(
                          child: Text(
                            'No boats found. Try adjusting your filters.',
                            style: getBodyTextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 320,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: yachts.length,
                            itemBuilder: (context, index) {
                              final yacht = yachts[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: SizedBox(
                                  width: 223,
                                  child: _YachtCard(
                                    yacht: yacht,
                                    onTap: () => Get.to(
                                      () => DetailsScreen(),
                                      arguments: yacht.id,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: filterController == null
                              ? null
                              : () => filterController.fetchNextPage(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.appPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Obx(
                              () {
                                final loadingMore =
                                    filterController?.isLoadingMore.value ==
                                        true;
                                final canLoadMore =
                                    filterController?.hasMore.value ?? false;
                                return loadingMore
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        canLoadMore ? 'Show more' : 'No more',
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YachtCard extends StatelessWidget {
  const _YachtCard({required this.yacht, required this.onTap});

  final Yacht yacht;
  final VoidCallback onTap;

  Widget _buildDetail(String label, String value) {
    final safeValue = value.isEmpty ? 'N/A' : value;
    final shortValue =
        safeValue.substring(0, safeValue.length > 10 ? 10 : safeValue.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: getBodyTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          shortValue,
          style: getBodyTextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                yacht.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            yacht.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBodyTextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      yacht.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetail('Make', yacht.make),
                        _buildDetail('Model', yacht.model),
                        _buildDetail('Year', yacht.year),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Price: ${yacht.price}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00A3AC),
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
  }
}
