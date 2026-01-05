import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';

class DetailsThumbnailGallery extends StatelessWidget {
  const DetailsThumbnailGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    return Obx(() {
      final imgs = controller.images;

      // If there are no images, show nothing (remove local dummy assets)
      if (imgs.isEmpty) {
        return const SizedBox.shrink();
      }

      // show first 3 images as before but without local asset fallbacks
      return Padding(
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgs[0],
                height: 152,
                width: 185,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imgs.length > 1 ? imgs[1] : imgs[0],
                    height: 71,
                    width: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imgs.length > 2 ? imgs[2] : imgs[0],
                        height: 71,
                        width: 128,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 20,
                        width: 80,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'See All Photo',
                            style: TextStyle(
                              color: Color(0xFF006EF0),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
