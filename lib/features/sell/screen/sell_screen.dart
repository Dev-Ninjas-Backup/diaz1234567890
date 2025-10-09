import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/iconpath.dart';
import 'package:diaz1234567890/features/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widget/custom_button.dart';
import '../../../core/utils/constants/imagepath.dart';

class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FEFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(
                      Imagepath.registerBoatImage,
                      fit: BoxFit.cover,
                    ),
                  ),
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
      ),
    );
  }
}
