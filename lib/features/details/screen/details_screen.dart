import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailsController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 244,
                  width: double.infinity,
                  child: PageView.builder(
                    itemCount: controller.images.length,
                    onPageChanged: controller.onPageChanged,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          controller.images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
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
                          width: controller.currentIndex.value == index
                              ? 10
                              : 8,
                          height: controller.currentIndex.value == index
                              ? 10
                              : 8,
                          decoration: BoxDecoration(
                            color: controller.currentIndex.value == index
                                ? Colors.blue
                                : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (controller.currentIndex.value == index)
                                BoxShadow(
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
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(26, 20, 26, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      Imagepath.room1,
                      height: 152,
                      width: 185,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          Imagepath.room2,
                          height: 71,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              Imagepath.room3,
                              height: 71,
                              width: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Image.asset(
                                Imagepath.seeAllButton,
                                height: 20,
                                width: 81,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
              child: Text(
                '2018 Viking 80 Enclosed Skybridge',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price: \$1,195,000',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Montauk, NY',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Image.asset(Iconpath.askAiIcon, height: 30, width: 74),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 26,
                vertical: 24,
              ),

              child: Text(
                'Specifications',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 26),
              child: Image.asset(
                Imagepath.detailsTable,
                width: double.infinity,
                height: 496,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 26,
                vertical: 24,
              ),
              child: Image.asset(
                Imagepath.fullDetailsFrame,
                width: double.infinity,
                height: 2242,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
