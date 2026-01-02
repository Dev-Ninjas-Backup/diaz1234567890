import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldsWidget extends StatelessWidget {
  final String title;
  final String hint;
  final bool isDropdown;

  const FieldsWidget({
    super.key,
    required this.title,
    required this.hint,
    this.isDropdown = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellPackageController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        isDropdown
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Obx(
                  () => DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: controller.selectedBuildYear.value,
                      hint: Text(
                        hint,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      isExpanded: true,
                      items: controller.year.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: controller.selectBuildYear,
                    ),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
      ],
    );
  }
}
