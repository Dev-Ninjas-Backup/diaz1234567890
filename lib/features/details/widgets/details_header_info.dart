import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/details_controller.dart';

class DetailsHeaderInfo extends StatelessWidget {
  const DetailsHeaderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    return Obx(() {
      final boat = controller.boat.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            child: Text(
              boat?.name ?? '',
              style: const TextStyle(
                fontSize: 13,
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
                      'Price: \$${boat != null ? boat.price.toString() : '1,195,000'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boat != null
                          ? '${boat.city ?? ''}, ${boat.state ?? ''}'
                          : 'Montauk, NY',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE1E7FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          'Ask Ai',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
