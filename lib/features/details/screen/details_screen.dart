import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:diaz1234567890/features/details/widgets/details_description.dart';
import 'package:diaz1234567890/features/details/widgets/details_header_info.dart';
import 'package:diaz1234567890/features/details/widgets/details_image_slider.dart';
import 'package:diaz1234567890/features/details/widgets/details_map_section.dart';
import 'package:diaz1234567890/features/details/widgets/details_specifications.dart';
import 'package:diaz1234567890/features/details/widgets/details_thumbnail_gallery.dart';
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
            DetailsImageSlider(controller: controller),
            DetailsThumbnailGallery(),
            DetailsHeaderInfo(),
            DetailsSpecifications(),
            DetailsDescription(),
            DetailsMapSection(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
