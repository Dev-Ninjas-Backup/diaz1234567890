import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widget/custom_button.dart';
import '../controller/package_controller.dart';
import '../widgets/package_card.dart';

class SellPackageScreen extends StatelessWidget {
  const SellPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellPackageController(), permanent: false);

    return Scaffold(
      backgroundColor: Color(0xFFF5FEFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF006EF0),
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Register Your Boat",
            style: getTextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Listing Progress",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Step 1",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                            color: Colors.grey,
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
                            color: Colors.grey,
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
                            color: Colors.grey,
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
                SizedBox(height: 24),
                Text(
                  'Select a Package',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24),
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (controller.packages.isEmpty) {
                    return Center(child: Text('No packages available'));
                  }

                  return Column(
                    children: controller.packages.map((pkg) {
                      final isSelected =
                          controller.selectedPackage.value == pkg.title;
                      final priceString =
                          '\$${pkg.price.toStringAsFixed(2)} /${pkg.billingPeriodMonths == 1 ? 'month' : '${pkg.billingPeriodMonths} months'}';

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            child: PackageCard(
                              title: pkg.title,
                              price: priceString,
                              features: pkg.benefits,
                              tag: pkg.tag,
                              // ignore: deprecated_member_use
                              color: pkg.color.withOpacity(0.1),
                              buttonColor: pkg.buttonColor,
                              isSelected: isSelected,
                              onTap: () => controller.selectPackage(pkg.title),
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  );
                }),
                SizedBox(height: 20),
                CustomButton(
                  label: "Next →",
                  onPressed: () {
                    Get.toNamed('/packageScreenStep2');
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
