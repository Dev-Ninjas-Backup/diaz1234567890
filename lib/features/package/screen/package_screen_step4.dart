import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/package/widgets/listing_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageScreenStep4 extends StatelessWidget {
  const PackageScreenStep4({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellPackageController>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Register Your Boat'),
      body: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 25,
          left: 26,
          right: 26,
          bottom: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Listing Progress",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Step 4",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Select Package",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Boat Information",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Seller Information",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Pay & Post",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Text(
              'Preview Listing',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 25),
            Obx(
              () => Center(
                child: ListingPreviewCard(
                  boatName: controller.nameController.text,
                  boatYear: controller.selectedBuildYear.value,
                  boatMake: controller.selectedMake.value,
                  boatModel: controller.modelController.text,
                  price: controller.priceController.text,
                  location:
                      '${controller.selectedBoatCity.value ?? ''}, ${controller.selectedBoatState.value ?? ''}',
                  coverImagePath: controller.coverImage.value?.path,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(
              () => CustomButton(
                label: controller.isLoading.value
                    ? "Processing..."
                    : "Continue to payment →",
                onPressed: controller.isLoading.value
                    ? () {}
                    : () async {
                        await controller.submitBoatOnboarding();
                      },
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
