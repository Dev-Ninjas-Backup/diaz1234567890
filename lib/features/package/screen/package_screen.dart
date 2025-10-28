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
    final controller = Get.put(SellPackageController());

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
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Listing progress",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 2,
                      color: const Color.fromARGB(255, 214, 214, 214),
                    ),
                    SizedBox(width: 10),
                    Container(width: 10, height: 2, color: Colors.grey),
                    SizedBox(width: 10),
                    Container(width: 10, height: 2, color: Colors.grey),
                    SizedBox(width: 10),
                    Container(width: 10, height: 2, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Select Package",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Dynamically generate package cards
                Obx(
                  () => Column(
                    children: controller.packages.map((pkg) {
                      final isSelected =
                          controller.selectedPackage.value == pkg.title;

                      return Column(
                        children: [
                          PackageCard(
                            title: pkg.title,
                            price: pkg.price,
                            features: pkg.features,
                            tag: pkg.tag,
                            color: pkg.color.withOpacity(0.1),
                            buttonColor: pkg.buttonColor,
                            isSelected: isSelected,
                            onTap: () => controller.selectPackage(pkg.title),
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                SizedBox(height: 20),
                CustomButton(
                  label: "Next →",
                  onPressed: () {
                    // navigate next
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
