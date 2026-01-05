import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';

class DetailsMapSection extends StatelessWidget {
  const DetailsMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    return Obx(() {
      final b = controller.boat.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Text(
              "Location in Map",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  b != null
                      ? '${b.city ?? ''}, ${b.state ?? ''}'
                      : 'Montauk, NY',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 26),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                b != null
                    ? '${b.city ?? ''}, ${b.state ?? ''}'
                    : 'Map Placeholder',
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    });
  }
}
