import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/features/about_us/controller/about_us_controller.dart';
import 'package:diaz1234567890/features/about_us/widgets/get_in_touch_card.dart';
import 'package:diaz1234567890/features/about_us/widgets/mission_vision_section.dart';
import 'package:diaz1234567890/features/about_us/widgets/working_hour_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AboutUsController controller = Get.put(AboutUsController());

    return Scaffold(
      backgroundColor: AppColors.appSecondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 104,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.54, 1.00),
                  end: Alignment(0.54, -0.00),
                  colors: [const Color(0xFF00CABE), const Color(0xFF006EF0)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 6,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          margin: const EdgeInsets.only(left: 16),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'About Us',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                        ),
                      ),
                      const SizedBox(width: 52),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            SizedBox(height: 30),
            Obx(() {
              // Show loading state
              if (controller.isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.appPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Loading team...'),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                      () => Text(
                        controller.aboutTitle.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.20,
                          letterSpacing: 1.46,
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Obx(
                      () => Text(
                        controller.aboutDescription.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF4A4D4D),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.35,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(
                      () => controller.image1Url.value.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              height: 177,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    controller.image1Url.value,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 177,
                              decoration: ShapeDecoration(
                                color: Colors.grey.shade200,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 16),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          controller.image2Url.value.isNotEmpty
                              ? Container(
                                  width: 160,
                                  height: 134,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        controller.image2Url.value,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 160,
                                  height: 134,
                                  decoration: ShapeDecoration(
                                    color: Colors.grey.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                          controller.image3Url.value.isNotEmpty
                              ? Container(
                                  width: 160,
                                  height: 134,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        controller.image3Url.value,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 160,
                                  height: 134,
                                  decoration: ShapeDecoration(
                                    color: Colors.grey.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    const MissionVisionSection(),
                    SizedBox(height: 40),
                    Text(
                      'WHAT SETS US APART',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.20,
                        letterSpacing: 1.46,
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(
                      () => Text(
                        controller.whatSetsUsApartDescription.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF4A4D4D),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.35,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                          Expanded(
                            child:
                                controller
                                    .whatSetsUsApartImage1Url
                                    .value
                                    .isNotEmpty
                                ? Container(
                                    height: 160,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          controller
                                              .whatSetsUsApartImage1Url
                                              .value,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 160,
                                    decoration: ShapeDecoration(
                                      color: Colors.grey.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child:
                                controller
                                    .whatSetsUsApartImage2Url
                                    .value
                                    .isNotEmpty
                                ? Container(
                                    height: 160,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          controller
                                              .whatSetsUsApartImage2Url
                                              .value,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 160,
                                    decoration: ShapeDecoration(
                                      color: Colors.grey.shade200,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image,
                                        size: 40,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.59,
                        vertical: 11.45,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFDCFCFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11.45),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 22.90,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.whatSetsUsApartYears.value.isEmpty
                                      ? ''
                                      : controller.whatSetsUsApartYears.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF001416),
                                    fontSize: 17.17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                'Years of\nYachting Excellence',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF4A4D4D),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller.whatSetsUsApartBoats.value.isEmpty
                                      ? ''
                                      : controller.whatSetsUsApartBoats.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF001416),
                                    fontSize: 17.17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                'Boats\nSold in 2024',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF4A4D4D),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Text(
                                  controller
                                          .whatSetsUsApartListings
                                          .value
                                          .isEmpty
                                      ? ''
                                      : controller
                                            .whatSetsUsApartListings
                                            .value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF001416),
                                    fontSize: 17.17,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                'of Listings\nviewed monthly',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF4A4D4D),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    // MeetTeam(),
                    SizedBox(height: 30),
                    GetInTouchCard(
                      address: controller.address,
                      email: controller.email,
                      phone: controller.phone,
                      socialMedia: controller.socialMedia,
                      backgroundImageUrl: controller.contactBackgroundImage,
                    ),
                    SizedBox(height: 20),
                    WorkingHourCard(
                      workingHours: controller.workingHours,
                      backgroundImageUrl: controller.contactBackgroundImage,
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
