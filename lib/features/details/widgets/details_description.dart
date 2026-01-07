import 'package:diaz1234567890/features/details/widgets/details_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';

class DetailsDescription extends StatelessWidget {
  const DetailsDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    return Obx(() {
      final b = controller.boat.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              b?.description.isNotEmpty == true
                  ? b!.description
                  : 'Note: ONLY 1600 HOURS WITH EXTENDED WARRANTY UNTIL MAY 2025 OR 2700 HOURS',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            if (b?.extraDetails.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              for (final d in b!.extraDetails)
                ExpansionTile(
                  title: Text(d.title),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      child: Text(d.description),
                    ),
                  ],
                ),
            ],
            const SizedBox(height: 8),
            const DetailsExpansionTileList(),
          ],
        ),
      );
    });
  }

  // Widget _buildFeatureItem(String text) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 2.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text('• ', style: TextStyle(fontSize: 12)),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: const TextStyle(fontSize: 11, height: 1.1),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
