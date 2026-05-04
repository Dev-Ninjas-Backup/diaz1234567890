import 'package:diaz1234567890/features/home/controller/filter_controller.dart';
import 'package:diaz1234567890/features/home/screen/home_filtered_listings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key, required this.searchControllerTag});

  final String searchControllerTag;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      FilterController(searchControllerTag: searchControllerTag),
      tag: 'home_filter_$searchControllerTag',
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 340,
              decoration: const BoxDecoration(
                color: Color(0xFFF5FEF5),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                        const Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.resetFilters,
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0079B3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Price Range'),
                        const SizedBox(height: 12),
                        _priceRange(controller),
                        const SizedBox(height: 20),

                        _sectionTitle('Make'),
                        const SizedBox(height: 10),
                        _dropdown(
                          value: controller.selectedMake,
                          items: controller.makes,
                          hint: 'Select Make',
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle('Model'),
                        const SizedBox(height: 10),
                        _dropdown(
                          value: controller.selectedModel,
                          items: controller.models,
                          hint: 'Select Model',
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle('Class'),
                        const SizedBox(height: 10),
                        _dropdown(
                          value: controller.selectedClass,
                          items: controller.classes,
                          hint: 'Select Class',
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle('Build Year (Start / End)'),
                        const SizedBox(height: 10),
                        _rangeInputs(
                          leftController: controller.buildYearStartController,
                          rightController: controller.buildYearEndController,
                          leftHint: 'Start',
                          rightHint: 'End',
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle('Length (ft) (Start / End)'),
                        const SizedBox(height: 10),
                        _rangeInputs(
                          leftController: controller.lengthStartController,
                          rightController: controller.lengthEndController,
                          leftHint: 'Min',
                          rightHint: 'Max',
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle('Beam Size (Start / End)'),
                        const SizedBox(height: 10),
                        _rangeInputs(
                          leftController: controller.beamStartController,
                          rightController: controller.beamEndController,
                          leftHint: 'Min',
                          rightHint: 'Max',
                        ),
                        const SizedBox(height: 20),

                        _sectionTitle('Engines / Heads / Cabins'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _numberField(
                                controller: controller.enginesNumberController,
                                hint: 'Engines',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _numberField(
                                controller: controller.headsNumberController,
                                hint: 'Heads',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _numberField(
                                controller: controller.cabinsNumberController,
                                hint: 'Cabins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),

                        Center(
                          child: Obx(
                            () => GestureDetector(
                              onTap: controller.isApplyingFilters.value
                                  ? null
                                  : () async {
                                      await controller.applyFilters();
                                      Get.back();
                                      Get.to(
                                        () => HomeFilteredListingsPage(
                                          searchControllerTag: searchControllerTag,
                                        ),
                                      );
                                    },
                              child: Container(
                                width: 170,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF006EF0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: controller.isApplyingFilters.value
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'Show Results',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      );

  Widget _priceRange(FilterController controller) {
    return Obx(
      () => Column(
        children: [
          RangeSlider(
            values: RangeValues(controller.priceStart.value, controller.priceEnd.value),
            min: 0,
            max: 5000000,
            activeColor: const Color(0xFF0079B3),
            inactiveColor: Colors.grey.shade300,
            onChanged: (values) {
              controller.priceStart.value = values.start;
              controller.priceEnd.value = values.end;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${controller.priceStart.value.toInt()}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF4A4D4D))),
              Text('\$${controller.priceEnd.value.toInt()}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF4A4D4D))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropdown({
    required RxnString value,
    required List<String> items,
    required String hint,
  }) {
    return Obx(
      () => Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<String?>(
          value: value.value,
          isExpanded: true,
          underline: const SizedBox(),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(hint, style: const TextStyle(fontSize: 12, color: Color(0xFF4A4D4D))),
            ),
            ...items.map(
              (e) => DropdownMenuItem<String?>(
                value: e,
                child: Text(e, style: const TextStyle(fontSize: 12, color: Color(0xFF4A4D4D))),
              ),
            ),
          ],
          onChanged: (v) => value.value = v,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ),
    );
  }

  Widget _rangeInputs({
    required TextEditingController leftController,
    required TextEditingController rightController,
    required String leftHint,
    required String rightHint,
  }) {
    return Row(
      children: [
        Expanded(child: _numberField(controller: leftController, hint: leftHint)),
        const SizedBox(width: 10),
        Expanded(child: _numberField(controller: rightController, hint: rightHint)),
      ],
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

