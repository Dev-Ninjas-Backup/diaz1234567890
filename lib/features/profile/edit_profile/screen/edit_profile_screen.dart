import 'dart:io';
import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/profile/edit_profile/controller/edit_profile_controller.dart';
import 'package:diaz1234567890/features/profile/edit_profile/widget/edit_fields_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Obx(() {
                      final File? imageFile = controller.selectedImage.value;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: imageFile != null
                            ? Image.file(
                                imageFile,
                                height: 68,
                                width: 68,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                Imagepath.user,
                                height: 68,
                                width: 68,
                                fit: BoxFit.cover,
                              ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.edit, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const EditFieldsWidget(
                title: 'Full Name: *',
                hint: 'Update Name',
              ),
              const EditFieldsWidget(
                title: 'Contact Number: *',
                hint: 'Update Contact Number',
              ),
              const EditFieldsWidget(
                title: 'Country: *',
                hint: 'Update Country',
              ),
              const EditFieldsWidget(title: 'City: *', hint: 'Update City'),
              const EditFieldsWidget(
                title: 'Phone Number:',
                hint: 'Update Phone Number',
              ),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const EditFieldsWidget(
                title: 'Enter Old Password: *',
                hint: '********',
              ),
              const EditFieldsWidget(
                title: 'Enter New Password: *',
                hint: '********',
              ),
              const EditFieldsWidget(
                title: 'Enter Confirm Password: *',
                hint: '********',
              ),
              const SizedBox(height: 10),
              CustomButton(
                label: 'Save Change',
                onPressed: () {
                  Get.snackbar('Success', 'Saved Changes');
                  Get.offAllNamed('/profileScreen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
