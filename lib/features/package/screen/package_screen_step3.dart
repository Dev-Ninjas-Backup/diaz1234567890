import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/package/widgets/text_field_widget.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step1.dart';
import 'package:diaz1234567890/features/profile/edit_profile/widget/edit_fields_widget.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';

class SellPackageScreen extends StatefulWidget {
  const SellPackageScreen({super.key});

  @override
  State<SellPackageScreen> createState() => _SellPackageScreenState();
}

class _SellPackageScreenState extends State<SellPackageScreen> {
  @override
  void initState() {
    super.initState();
    // Skip this page if user is already logged in
    if (StorageService.hasToken()) {
      Future.microtask(() {
        Get.off(() => SellPackageScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellPackageController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Register Your Boat'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Contact Details',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextFieldWidget(
                title1: 'First Name: *',
                title2: 'Last Name: *',
                hint1: 'Type here',
                hint2: 'Type here',
                controller1: controller.sellerNameController,
                controller2: TextEditingController(), // Combined in seller name
              ),
              SizedBox(height: 14),
              TextFieldWidget(
                title1: 'Contact Number: *',
                title2: 'Email: *',
                hint1: 'Type here',
                hint2: 'Type here',
                controller1: controller.sellerPhoneController,
                controller2: controller.sellerEmailController,
              ),
              SizedBox(height: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Country: *',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    //height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Obx(
                      () => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedCountry.value,
                          hint: Text(
                            'Select',
                            style: TextStyle(color: Colors.grey),
                          ),
                          isExpanded: true,
                          items: controller.countries.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: controller.selectCountry,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'City: *',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        //height: 36,
                        width: 98,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedCity.value,
                              hint: Text(
                                'Select',
                                style: TextStyle(color: Colors.grey),
                              ),
                              isExpanded: true,
                              items: controller.cities.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: controller.selectCity,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'State: *',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        //height: 36,
                        width: 98,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedState.value,
                              hint: Text(
                                'Select',
                                style: TextStyle(color: Colors.grey),
                              ),
                              isExpanded: true,
                              items: controller.states.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: controller.selectState,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zip: *',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        //height: 36,
                        width: 98,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: controller.sellerZipController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type here',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text(
                'Seller Account Information',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 24),
              EditFieldsWidget(
                title: 'Username: *',
                hint: 'username',
                controller: controller.sellerUsernameController,
              ),
              EditFieldsWidget(
                title: 'Password: *',
                hint: '********',
                controller: controller.sellerPasswordController,
                obscureText: true,
              ),
              EditFieldsWidget(
                title: 'Confirm Password: *',
                hint: '********',
                controller: controller.sellerConfirmPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 40),
              Obx(
                () => CustomButton(
                  label: controller.isLoading.value
                      ? "Registering..."
                      : "Next →",
                  onPressed: controller.isLoading.value
                      ? () {}
                      : () {
                          controller.registerSellerAccount();
                        },
                  width: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
