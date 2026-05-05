import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import '../controller/details_controller.dart';
import 'contact_owner_dialog.dart';

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
                CustomButton(
                  label: 'Contact Owner',
                  width: 130,
                  height: 34,
                  borderRadius: 8,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  onPressed: () {
                    final listingId = boat?.id ?? '';
                    showDialog(
                      context: context,
                      builder: (_) => ContactOwnerDialog(listingId: listingId),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
