import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/need_help/widgets/get_in_touch_card.dart';
import 'package:diaz1234567890/features/need_help/widgets/working_hour_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/need_help_controller.dart';

class NeedHelpScreen extends StatelessWidget {
  const NeedHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NeedHelpController controller = Get.put(NeedHelpController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Imagepath.coverImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  'Get in Touch with\n Florida Yacht Traders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
            ),

            // DYNAMIC CONTENT: Wrap only the parts that change based on API
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 50.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField(
                      'Full Name*',
                      'John Doe',
                      controller.nameController,
                    ),
                    _buildTextField(
                      'Phone*',
                      '123*******',
                      controller.phoneController,
                    ),
                    _buildTextField(
                      'Email*',
                      'john@example.com',
                      controller.emailController,
                    ),
                    _buildTextField(
                      'Boat Information:',
                      'Type your message...',
                      controller.boatInfoController,
                    ),
                    _buildTextField(
                      'Comments',
                      'Type your message...',
                      controller.commentsController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: controller.isSending.value
                              ? null
                              : () => controller.submitRequest(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006EF0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            controller.isSending.value
                                ? 'Sending...'
                                : 'Send Message',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 39.60,
                            height: 39.60,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset(Iconpath.supportIcon),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Return Policy',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.85,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.34,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'All vessels purchased through Jupiter Marine Sales are advised to go through a survey, sea trial, and mechanical inspection. Once these inspections have happened and the vessel is checked to the buyers satisfaction we will send out a form called vessel acceptance for closing. After vessel acceptance is signed by the buyer or buyers there are no returns, exchanges.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF6C6F6F) /* grey-400 */,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    GetInTouchCard(
                      address: controller.address,
                      email: controller.contactEmail,
                      phone: controller.contactPhone,
                      socialMedia: controller
                          .socialMedia,
                      backgroundImageUrl: controller.headerImageUrl,
                    ),
                    const SizedBox(height: 20),
                    WorkingHourCard(
                      workingHours: controller.workingHours,
                      backgroundImageUrl:
                          controller.headerImageUrl, 
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController ctr, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctr,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
