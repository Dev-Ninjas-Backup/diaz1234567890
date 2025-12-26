import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widget/custom_button.dart';
import '../../../core/utils/constants/image_path.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                  child: Image.asset(
                    Imagepath.ship2,
                    height: 244,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100), // Move text down
                      Text(
                        "Register Your Boat",
                        style: getTextStyle(
                            fontSize: 20, // Smaller size
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Join our global network of verified yacht sellers and\nreach high-value buyers worldwide",
                        textAlign: TextAlign.center,
                        style: getTextStyle(
                            fontSize: 12, color: Colors.white), // Smaller size
                      ),
                    ],
                  ),
                )
              ],
            ),

            SizedBox(height: 100),
            Align(
              alignment: AlignmentGeometry.center,
              child: SizedBox(
                child: Image.asset(Iconpath.noListIcon, fit: BoxFit.contain),
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: AlignmentGeometry.center,
              child: Text(
                "No listing available",
                style: getTextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 50),
            CustomButton(
              label: "Create New Listing",
              icon: Icons.add,
              onPressed: () {
                Get.to(SellPackageScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
