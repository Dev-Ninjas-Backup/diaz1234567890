// ignore_for_file: avoid_print

import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/package/widgets/text_field_widget.dart';
import 'package:diaz1234567890/features/package/widgets/text_field_widget2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'dart:io';

class PackageScreenStep2 extends StatefulWidget {
  const PackageScreenStep2({super.key});

  @override
  State<PackageScreenStep2> createState() => _PackageScreenStep2State();
}

class _PackageScreenStep2State extends State<PackageScreenStep2> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<SellPackageController>();
    final boatId = Get.arguments;

    if (boatId is String && boatId.isNotEmpty) {
      print('[DEBUG] PackageScreenStep2: Edit mode for boat ID: $boatId');
      controller.fetchBoatDetailsForEdit(boatId);
    } else {
      print('[DEBUG] PackageScreenStep2: Create mode - clearing form');
      controller.clearAllControllers();
      controller.isEditMode.value = false;
    }
  }

  Widget _buildProgressStep(String label, bool isCompleted, bool isCurrent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 62,
          height: 6,
          decoration: BoxDecoration(
            color: isCompleted ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 8, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              hint: Text(hint, style: TextStyle(color: Colors.grey)),
              isExpanded: true,
              items: items
                  .map(
                    (type) => DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEngineSection(int engineIndex, EngineDetail engine) {
    final controller = Get.find<SellPackageController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Engine ${engineIndex + 1}',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12),
        TextFieldWidget(
          title1: 'Hours:',
          title2: 'Make: *',
          hint1: 'Type here',
          hint2: 'Type here',
          controller1: engine.hoursController,
          controller2: engine.makeController,
        ),
        SizedBox(height: 14),
        TextFieldWidget(
          title1: 'Model:',
          title2: 'Total Power (HP):',
          hint1: 'Type here',
          hint2: 'Type here',
          controller1: engine.modelController,
          controller2: engine.horsepowerController,
        ),
        SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Obx(
                () => _buildDropdownField(
                  label: 'Fuel Type:',
                  value: engine.fuelTypeValue.value,
                  hint: 'Select',
                  items: controller.fuelType,
                  onChanged: (value) => engine.fuelTypeValue.value = value,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Obx(
                () => _buildDropdownField(
                  label: 'Propeller Type:',
                  value: engine.propellerTypeValue.value,
                  hint: 'Select',
                  items: controller.propellerTypes,
                  onChanged: (value) => engine.propellerTypeValue.value = value,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SellPackageController>();

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: controller.isEditMode.value
              ? 'Edit Boat Listing'
              : 'Register Your Boat',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!controller.isEditMode.value)
                  Row(
                    children: [
                      Text(
                        "Listing Progress",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Step 2",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                if (!controller.isEditMode.value) SizedBox(height: 14),
                if (!controller.isEditMode.value)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildProgressStep("Select Package", true, false),
                      SizedBox(width: 12),
                      _buildProgressStep("Boat Information", true, true),
                      SizedBox(width: 12),
                      // _buildProgressStep("Seller Information", false, false),
                      // SizedBox(width: 12),
                      _buildProgressStep("Pay & Post", false, false),
                    ],
                  ),
                if (!controller.isEditMode.value) Divider(),
                SizedBox(height: 32),
                Text(
                  'Boat Details',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFieldWidget(
                  title1: 'Boat Name: *',
                  title2: 'Price: *',
                  hint1: 'e.g., Sapphire',
                  hint2: 'e.g., 125000.5',
                  controller1: controller.nameController,
                  controller2: controller.priceController,
                ),
                SizedBox(height: 14),
                TextFieldWidget(
                  title1: 'Model: *',
                  title2: 'Description:',
                  hint1: 'e.g., Oceanis 38',
                  hint2: 'Boat description',
                  controller1: controller.modelController,
                  controller2: controller.descriptionController,
                ),
                SizedBox(height: 14),
                TextFieldWidget(
                  title1: 'City: *',
                  title2: 'Zip: *',
                  hint1: 'e.g., Miami',
                  hint2: '33101',
                  controller1: controller.boatCityController,
                  controller2: controller.boatZipController,
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'State: *',
                          value: controller.selectedBoatState.value,
                          hint: 'Select',
                          items: controller.states,
                          onChanged: controller.selectBoatState,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Condition: *',
                          value: controller.selectedCondition.value,
                          hint: 'Select',
                          items: controller.conditions,
                          onChanged: controller.selectCondition,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Prop Material: *',
                          value: controller.selectedPropMaterial.value,
                          hint: 'Select',
                          items: controller.propMaterials,
                          onChanged: controller.selectPropMaterial,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(child: Container()),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  'Boat Dimensions',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  title1: 'Length - Feet: *',
                  title2: 'Length - Inches: *',
                  hint1: '36',
                  hint2: '6',
                  controller1: controller.lengthFeetController,
                  controller2: controller.lengthInchesController,
                  isNumeric: true,
                  maxLength1: 3,
                  maxLength2: 2,
                ),
                SizedBox(height: 14),
                TextFieldWidget(
                  title1: 'Beam - Feet:',
                  title2: 'Beam - Inches:',
                  hint1: '12',
                  hint2: '6',
                  controller1: controller.beamFeetController,
                  controller2: controller.beamInchesController,
                  isNumeric: true,
                  maxLength1: 3,
                  maxLength2: 2,
                ),
                SizedBox(height: 14),
                TextFieldWidget(
                  title1: 'Draft - Feet:',
                  title2: 'Draft - Inches:',
                  hint1: '3',
                  hint2: '2',
                  controller1: controller.draftFeetController,
                  controller2: controller.draftInchesController,
                  isNumeric: true,
                  maxLength1: 3,
                  maxLength2: 2,
                ),

                const SizedBox(height: 24),

                Text(
                  'Specifications',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Build Year: *',
                          value: controller.selectedBuildYear.value,
                          hint: 'Select',
                          items: controller.year,
                          onChanged: controller.selectBuildYear,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Make: *',
                          value: controller.selectedMake.value,
                          hint: 'Select',
                          items: controller.make,
                          onChanged: controller.selectMake,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Class: *',
                          value: controller.selectedClass.value,
                          hint: 'Select',
                          items: controller.boatClass,
                          onChanged: controller.selectClass,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Material:',
                          value: controller.selectedMaterial.value,
                          hint: 'Select',
                          items: controller.material,
                          onChanged: controller.selectMaterial,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Fuel Type: *',
                          value: controller.selectedFuelType.value,
                          hint: 'Select',
                          items: controller.fuelType,
                          onChanged: controller.selectFuelType,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Number of Engine: *',
                          value: controller.selectedNumberOfEngine.value,
                          hint: 'Select',
                          items: controller.numberOfEngines,
                          onChanged: controller.selectNumberOfEngine,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Number of Cabin: *',
                          value: controller.selectedNumberOfCabin.value,
                          hint: 'Select',
                          items: controller.numberOfCabins,
                          onChanged: controller.selectNumberOfCabin,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Obx(
                        () => _buildDropdownField(
                          label: 'Number of Heads: *',
                          value: controller.selectedNumberOfHeads.value,
                          hint: 'Select',
                          items: controller.numberOfHeads,
                          onChanged: controller.selectNumberOfHeads,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                Text(
                  'Engine',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 24),
                // Dynamic engine details based on number of engines
                Obx(() {
                  final showDynamicEngines = controller.engines.isNotEmpty;

                  if (showDynamicEngines) {
                    // Show dynamic engines
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < controller.engines.length; i++)
                          _buildEngineSection(i, controller.engines[i]),
                      ],
                    );
                  } else {
                    // Fallback to single engine (legacy)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldWidget(
                          title1: 'Hours:',
                          title2: 'Make: *',
                          hint1: 'Type here',
                          hint2: 'Type here',
                          controller1: controller.engineHoursController,
                          controller2: controller.engineMakeController,
                        ),
                        SizedBox(height: 14),
                        TextFieldWidget(
                          title1: 'Model:',
                          title2: 'Total Power (HP):',
                          hint1: 'Type here',
                          hint2: 'Type here',
                          controller1: controller.engineModelController,
                          controller2: controller.engineHorsepowerController,
                        ),
                        SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(
                                () => _buildDropdownField(
                                  label: 'Fuel Type:',
                                  value:
                                      controller.selectedEngineFuelType.value,
                                  hint: 'Select',
                                  items: controller.fuelType,
                                  onChanged: controller.selectEngineFuelType,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Obx(
                                () => _buildDropdownField(
                                  label: 'Propeller Type:',
                                  value: controller.selectedPropellerType.value,
                                  hint: 'Select',
                                  items: controller.propellerTypes,
                                  onChanged: controller.selectPropellerType,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                }),
                SizedBox(height: 30),
                Text(
                  'Media & Gallery',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextFieldWidget2(
                  title1: 'Video URL:',

                  hint1: 'YouTube URL',

                  controller1: controller.videoURLController,
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cover Image: *',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 6),
                    Obx(
                      () => Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade50,
                        ),
                        child: controller.coverImage.value != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(controller.coverImage.value!.path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: controller.removeCoverImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : controller.existingCoverImages.isNotEmpty
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      controller
                                              .existingCoverImages[0]['url'] ??
                                          '',
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.grey.shade200,
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        final imageId =
                                            controller
                                                .existingCoverImages[0]['id'] ??
                                            '';
                                        if (imageId.isNotEmpty) {
                                          controller.imagesToDelete.add(
                                            imageId,
                                          );
                                        }
                                        controller.existingCoverImages.clear();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Existing',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: controller.pickCoverImage,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Click to select cover image',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gallery Images:',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: controller.pickGalleryImages,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade50,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 24,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Click to select gallery images',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Obx(() {
                      final hasExisting =
                          controller.existingGalleryImages.isNotEmpty;
                      final hasNew = controller.galleryImages.isNotEmpty;
                      final totalCount =
                          controller.existingGalleryImages.length +
                          controller.galleryImages.length;

                      if (!hasExisting && !hasNew) {
                        return Text(
                          'No images selected',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: totalCount,
                        itemBuilder: (context, index) {
                          final isExisting =
                              index < controller.existingGalleryImages.length;

                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: isExisting
                                    ? Image.network(
                                        controller
                                                .existingGalleryImages[index]['url'] ??
                                            '',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: Icon(Icons.error),
                                        ),
                                      )
                                    : Image.file(
                                        File(
                                          controller
                                              .galleryImages[index -
                                                  controller
                                                      .existingGalleryImages
                                                      .length]
                                              .path,
                                        ),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    if (isExisting) {
                                      final imageId =
                                          controller
                                              .existingGalleryImages[index]['id'] ??
                                          '';
                                      if (imageId.isNotEmpty) {
                                        controller.imagesToDelete.add(imageId);
                                      }
                                      controller.existingGalleryImages.removeAt(
                                        index,
                                      );
                                    } else {
                                      controller.removeGalleryImage(
                                        index -
                                            controller
                                                .existingGalleryImages
                                                .length,
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                              if (isExisting)
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Existing',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      );
                    }),
                  ],
                ),
                SizedBox(height: 30),
                Obx(
                  () => CustomButton(
                    label: controller.isLoading.value
                        ? (controller.isEditMode.value
                              ? "Updating..."
                              : "Submitting...")
                        : (controller.isEditMode.value
                              ? "Update Listing"
                              : "Next →"),
                    onPressed: controller.isLoading.value
                        ? () {}
                        : () {
                            // Submit boat listing or update in edit mode
                            if (controller.isEditMode.value) {
                              controller.updateBoatListing();
                            } else {
                              controller.submitBoatOnboarding();
                            }
                          },
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
