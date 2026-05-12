import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step1.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step3.dart'
    as step3;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tahoea_liquid_glass/tahoea_liquid_glass.dart';

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

                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TahoeaLiquidGlass(
                        borderRadius: BorderRadius.circular(10.0),
                        blurSigma: 1,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Register Your Boat",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Join our global network of verified yacht sellers and\nreach high-value buyers worldwide",
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            Align(
              alignment: Alignment.center,
              child: Image.asset(Iconpath.noListIcon, fit: BoxFit.contain),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.center,
              child: Text(
                "No listing available",
                style: getTextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                label: "Create New Listing",
                icon: Icons.add,
                onPressed: () {
                  if (!Get.isRegistered<SellPackageController>()) {
                    Get.put(SellPackageController(), permanent: false);
                  }

                  if (StorageService.hasToken()) {
                    Get.to(() => PackageScreenStep1());
                  } else {
                    Get.to(() => step3.SellPackageScreen());
                  }
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
