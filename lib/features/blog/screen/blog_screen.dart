// ignore_for_file: deprecated_member_use

import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/blog/controller/blog_controller.dart';
import 'package:diaz1234567890/features/blog/widgets/blog_card.dart';
import 'package:diaz1234567890/features/blog/widgets/discover_more_section.dart';
import 'package:diaz1234567890/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key});
  final BlogController controller = Get.put(BlogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// 🔷 TOP BANNER
            Container(
              width: double.infinity,
              height: 244,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                image: DecorationImage(
                  image: AssetImage(Imagepath.blogImage1),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    'READ BLOG -MPS, TRENDS,\nAND MARKET INSIGHTS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 42),
                ],
              ),
            ),

            /// 🔷 CONTENT SECTION
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5FEFF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 11),

                    /// 🔷 FEATURED BLOG
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.errorMessage.value != null) {
                        return Center(
                          child: Text(
                            'Error: ${controller.errorMessage.value}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (controller.displayedPosts.isEmpty) {
                        return const Center(
                          child: Text('No featured blog available'),
                        );
                      }

                      final featuredPost = controller.displayedPosts[0];

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredPost.imageUrl.isNotEmpty
                              ? Container(
                                  width: 146,
                                  height: 172,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        featuredPost.imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.25),
                                      bottomLeft: Radius.circular(4.25),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 146,
                                  height: 172,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.25),
                                      bottomLeft: Radius.circular(4.25),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 35,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      featuredPost.readTime,
                                      style: const TextStyle(
                                        color: Color(0xFF6C6F6F),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      featuredPost.date,
                                      style: const TextStyle(
                                        color: Color(0xFF6C6F6F),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  featuredPost.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  height: 60,
                                  child: Html(data: featuredPost.excerpt),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoute.blogDetailsScreen,
                                      arguments: {'id': featuredPost.id},
                                    );
                                  },
                                  child: const Text(
                                    'Read More',
                                    style: TextStyle(
                                      color: Color(0xFF00A2AB),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 20),

                    /// 🔷 HORIZONTAL BLOG LIST
                    SizedBox(
                      height: 235,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.errorMessage.value != null) {
                          return Center(
                            child: Text(
                              'Error: ${controller.errorMessage.value}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }

                        if (controller.displayedPosts.isEmpty) {
                          return const Center(
                            child: Text('No blogs available'),
                          );
                        }

                        // Show only items from index 1 onwards (skip featured blog at index 0)
                        final remainingPosts = controller.displayedPosts
                            .skip(1)
                            .toList();

                        if (remainingPosts.isEmpty) {
                          return const Center(
                            child: Text('No more blogs available'),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: remainingPosts.length,
                          itemBuilder: (context, index) {
                            final post = remainingPosts[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: SizedBox(
                                width: 223,
                                child: BlogCard(
                                  post: post,
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoute.blogDetailsScreen,
                                      arguments: {'id': post.id},
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    SizedBox(height: 20),

                    /// 🔷 SHOW MORE / NO MORE BUTTON
                    Obx(() {
                      if (controller.hasMorePosts.value) {
                        return Center(
                          child: GestureDetector(
                            onTap: controller.isLoadingMore.value
                                ? null
                                : () {
                                    controller.loadMoreBlogs();
                                  },
                            child: Container(
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
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Show More',
                                      style: getTextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'No more blogs',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ).copyWith(color: Colors.grey[600]),
                            ),
                          ),
                        );
                      }
                    }),
                    SizedBox(height: 20),
                    DiscoverMoreSection(),
                    SizedBox(height: 20),
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
