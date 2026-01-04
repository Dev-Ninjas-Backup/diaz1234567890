import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/features/profile/my_listing/widget/my_listing_container.dart';
import 'package:diaz1234567890/features/profile/my_listing/controller/my_listing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyListingController controller = Get.put(MyListingController());

    return Scaffold(
      appBar: CustomAppBar(title: 'My Listing'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(25),
                child: Text(
                  'Preview Listing',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (controller.errorMessage.value.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ...controller.boats
                  .map((boat) => MyListingContainer(boat: boat))
                  .toList(),
            ],
          ),
        );
      }),
    );
  }
}
