import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/package/widgets/text_field_widget.dart';
import 'package:diaz1234567890/features/profile/edit_profile/widget/edit_fields_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';

class PackageScreenStep3 extends StatelessWidget {
  const PackageScreenStep3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellPackageController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Register Your Boat'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                    "Step 3",
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
              SizedBox(height: 32),
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
              ),
              SizedBox(height: 14),
              TextFieldWidget(
                title1: 'Contact Number: *',
                title2: 'Email: *',
                hint1: 'Type here',
                hint2: 'Type here',
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
                    height: 36,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text(
                          'Select',
                          style: TextStyle(color: Colors.grey),
                        ),
                        isExpanded: true,
                        value: null,
                        onChanged: (value) {},
                        items: [],
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
                        height: 36,
                        width: 98,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select',
                              style: TextStyle(color: Colors.grey),
                            ),
                            isExpanded: true,
                            value: null,
                            onChanged: (value) {},
                            items: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
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
                        height: 36,
                        width: 98,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: Text(
                              'Select',
                              style: TextStyle(color: Colors.grey),
                            ),
                            isExpanded: true,
                            value: null,
                            onChanged: (value) {},
                            items: [],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
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
                        height: 36,
                        width: 98,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextField(
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
              const EditFieldsWidget(title: 'Username: *', hint: 'username'),
              const EditFieldsWidget(title: 'Password: *', hint: '********'),
              const EditFieldsWidget(
                title: 'Confirm Password: *',
                hint: '********',
              ),
              SizedBox(height: 40),
              CustomButton(
                label: "Next →",
                onPressed: () {
                  if (kDebugMode) {
                    print(
                      'Selected Boat Type: ${controller.selectedBoatType.value}',
                    );
                  }
                },
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
