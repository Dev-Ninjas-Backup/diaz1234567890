import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsImageSlider extends StatelessWidget {
  final DetailsController controller;
  const DetailsImageSlider({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 244,
          width: double.infinity,
          child: Obx(() {
            // rebuild when controller.images changes
            if (kDebugMode) {
              final count = controller.images.length;
              if (count > 0) {
                print(
                  'Building image slider with $count images, first:${controller.images[0]}',
                );
              } else {
                print('Building image slider with 0 images');
              }
            }

            return PageView.builder(
              itemCount: controller.images.length,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  child: controller.images.isNotEmpty
                      ? Image.network(
                          controller.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                );
              },
            );
          }),
        ),
        Positioned(
          bottom: 12,
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.currentIndex.value == index ? 10 : 8,
                  height: controller.currentIndex.value == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: controller.currentIndex.value == index
                        ? Colors.blue
                        : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (controller.currentIndex.value == index)
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
