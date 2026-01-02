// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/api_service.dart';
import '../model/package_model.dart';

class SellPackageController extends GetxController {
  var selectedPackage = ''.obs;
  var selectedPackageId = ''.obs;
  var packages = <PackageModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Boat Info Text Controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final modelController = TextEditingController();
  final descriptionController = TextEditingController();
  final videoURLController = TextEditingController();
  final lengthFeetController = TextEditingController();
  final lengthInchesController = TextEditingController();
  final beamFeetController = TextEditingController();
  final beamInchesController = TextEditingController();
  final draftFeetController = TextEditingController();
  final draftInchesController = TextEditingController();
  final boatCityController = TextEditingController();
  final boatStateController = TextEditingController();
  final boatZipController = TextEditingController();

  // Engine Controllers
  final engineHoursController = TextEditingController();
  final engineMakeController = TextEditingController();
  final engineModelController = TextEditingController();
  final engineHorsepowerController = TextEditingController();

  // Seller Info Text Controllers
  final sellerNameController = TextEditingController();
  final sellerPhoneController = TextEditingController();
  final sellerEmailController = TextEditingController();
  final sellerUsernameController = TextEditingController();
  final sellerPasswordController = TextEditingController();
  final sellerConfirmPasswordController = TextEditingController();
  final sellerZipController = TextEditingController();

  // Specifications
  var selectedBuildYear = RxnString();
  var selectedMake = RxnString();
  var selectedClass = RxnString();
  var selectedMaterial = RxnString();
  var selectedFuelType = RxnString();
  var selectedNumberOfEngine = RxnString();
  var selectedNumberOfCabin = RxnString();
  var selectedNumberOfHeads = RxnString();
  var selectedCondition = RxnString();
  var selectedEngineType = RxnString();
  var selectedPropType = RxnString();
  var selectedPropMaterial = RxnString();
  var selectedBoatCity = RxnString();
  var selectedBoatState = RxnString();

  // File Picker
  final ImagePicker _picker = ImagePicker();
  var coverImage = Rxn<XFile>();
  var galleryImages = <XFile>[].obs;

  final List<String> year = ['2021', '2022', '2023', '2024', '2025'];
  final List<String> make = ['Yamaha', 'Sea Ray', 'Bayliner', 'Beneteau'];
  final List<String> boatClass = ['Class A', 'Class B', 'Class C'];
  final List<String> material = [
    'Fiberglass',
    'Aluminum',
    'Aluminium',
    'Steel',
  ];
  final List<String> fuelType = ['Gasoline', 'Diesel', 'Electric', 'Mercury'];
  final List<String> numberOfEngines = ['1', '2', '3+'];
  final List<String> numberOfCabins = ['1', '2', '3', '4+'];
  final List<String> numberOfHeads = ['1', '2', '3+'];
  final List<String> conditions = ['New', 'Used'];
  final List<String> engineTypes = ['Outboard', 'Inboard', 'Propeller'];
  final List<String> propTypes = ['Propeller', 'Fixed', 'Folding'];
  final List<String> propMaterials = ['Aluminium', 'Bronze', 'Stainless Steel'];
  final List<String> propellerTypes = ['12', '13', '14', '15'];

  void selectBuildYear(String? value) {
    selectedBuildYear.value = value;
  }

  void selectBoatType(String? type) {
    selectedBuildYear.value = type;
  }

  void selectMake(String? value) {
    selectedMake.value = value;
  }

  void selectClass(String? value) {
    selectedClass.value = value;
  }

  void selectMaterial(String? value) {
    selectedMaterial.value = value;
  }

  void selectFuelType(String? value) {
    selectedFuelType.value = value;
  }

  void selectNumberOfEngine(String? value) {
    selectedNumberOfEngine.value = value;
  }

  void selectNumberOfCabin(String? value) {
    selectedNumberOfCabin.value = value;
  }

  void selectNumberOfHeads(String? value) {
    selectedNumberOfHeads.value = value;
  }

  void selectCondition(String? value) {
    selectedCondition.value = value;
  }

  void selectEngineType(String? value) {
    selectedEngineType.value = value;
  }

  void selectPropType(String? value) {
    selectedPropType.value = value;
  }

  void selectPropMaterial(String? value) {
    selectedPropMaterial.value = value;
  }

  void selectBoatCity(String? value) {
    selectedBoatCity.value = value;
  }

  void selectBoatState(String? value) {
    selectedBoatState.value = value;
  }

  // Engine
  var selectedEngineFuelType = RxnString();
  var selectedPropellerType = RxnString();

  void selectEngineFuelType(String? value) {
    selectedEngineFuelType.value = value;
  }

  void selectPropellerType(String? value) {
    selectedPropellerType.value = value;
  }

  // File Picker Methods
  Future<void> pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        coverImage.value = image;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> pickGalleryImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        galleryImages.addAll(images);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeCoverImage() {
    coverImage.value = null;
  }

  void removeGalleryImage(int index) {
    galleryImages.removeAt(index);
  }

  // Contact Details
  var selectedCountry = RxnString();
  var selectedCity = RxnString();
  var selectedState = RxnString();

  final List<String> countries = ['USA', 'Canada', 'UK'];
  final List<String> cities = ['New York', 'Los Angeles', 'Toronto'];
  final List<String> states = ['California', 'New York', 'Ontario'];

  void selectCountry(String? value) {
    selectedCountry.value = value;
  }

  void selectCity(String? value) {
    selectedCity.value = value;
  }

  void selectState(String? value) {
    selectedState.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.getSubscriptionPlans();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        packages.value = data
            .map((item) => PackageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load packages';
      }
    } catch (e) {
      errorMessage.value = 'Error loading packages: $e';
      print('Error fetching packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectPackage(String title) {
    selectedPackage.value = title;
    // Find and set the package ID
    final package = packages.firstWhereOrNull((pkg) => pkg.title == title);
    if (package != null) {
      selectedPackageId.value = package.id;
    }
  }

  Future<void> submitBoatOnboarding() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Build boat info
      final boatInfo = {
        'name': nameController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'model': modelController.text,
        'make': selectedMake.value ?? '',
        'buildYear': int.tryParse(selectedBuildYear.value ?? '') ?? 0,
        'boatClass': selectedClass.value ?? '',
        'material': selectedMaterial.value ?? '',
        'fuelType': selectedFuelType.value ?? '',
        'condition': selectedCondition.value ?? 'Used',
        'engineType': selectedEngineType.value ?? '',
        'propType': selectedPropType.value ?? '',
        'propMaterial': selectedPropMaterial.value ?? '',
        'enginesNumber': int.tryParse(selectedNumberOfEngine.value ?? '1') ?? 1,
        'cabinsNumber': int.tryParse(selectedNumberOfCabin.value ?? '1') ?? 1,
        'headsNumber': int.tryParse(selectedNumberOfHeads.value ?? '1') ?? 1,
        'description': descriptionController.text,
        'videoURL': videoURLController.text,
        'city': selectedBoatCity.value ?? '',
        'state': selectedBoatState.value ?? '',
        'zip': boatZipController.text,
        'boatDimensions': {
          'lengthFeet': int.tryParse(lengthFeetController.text) ?? 0,
          'lengthInches': int.tryParse(lengthInchesController.text) ?? 0,
          'beamFeet': int.tryParse(beamFeetController.text) ?? 0,
          'beamInches': int.tryParse(beamInchesController.text) ?? 0,
          'draftFeet': int.tryParse(draftFeetController.text) ?? 0,
          'draftInches': int.tryParse(draftInchesController.text) ?? 0,
        },
        'engines': [
          {
            'hours': int.tryParse(engineHoursController.text) ?? 0,
            'horsepower': int.tryParse(engineHorsepowerController.text) ?? 0,
            'make': engineMakeController.text,
            'model': engineModelController.text,
            'fuelType': selectedEngineFuelType.value ?? '',
            'propellerType': selectedPropellerType.value ?? '',
          },
        ],
        'electronics': <String>[],
        'electricalEquipment': <String>[],
        'insideEquipment': <String>[],
        'outsideEquipment': <String>[],
        'coversEquipment': <String>[],
        'additionalEquipment': <String>[],
        'extraDetails': <Map<String, String>>[],
        'covers': coverImage.value != null ? [coverImage.value!.path] : [],
        'galleries': galleryImages.map((image) => image.path).toList(),
      };

      // Build seller info
      final sellerInfo = {
        'name': sellerNameController.text,
        'phone': sellerPhoneController.text,
        'email': sellerEmailController.text,
        'username': sellerUsernameController.text,
        'password': sellerPasswordController.text,
        'country': selectedCountry.value ?? '',
        'city': selectedCity.value ?? '',
        'state': selectedState.value ?? '',
        'zip': sellerZipController.text,
      };

      final response = await ApiService.createBoatOnboarding(
        boatInfo: boatInfo,
        sellerInfo: sellerInfo,
        planId: selectedPackageId.value,
      );

      if (response['success'] == true) {
        Get.snackbar(
          'Success',
          'Boat listing created successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        // Navigate to payment or success screen
      } else {
        errorMessage.value = response['message'] ?? 'Failed to create listing';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      errorMessage.value = 'Error submitting boat listing: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      print('Error submitting boat listing: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose all text controllers
    nameController.dispose();
    priceController.dispose();
    modelController.dispose();
    descriptionController.dispose();
    videoURLController.dispose();
    lengthFeetController.dispose();
    lengthInchesController.dispose();
    beamFeetController.dispose();
    beamInchesController.dispose();
    draftFeetController.dispose();
    draftInchesController.dispose();
    engineHoursController.dispose();
    engineMakeController.dispose();
    engineModelController.dispose();
    engineHorsepowerController.dispose();
    sellerNameController.dispose();
    sellerPhoneController.dispose();
    sellerEmailController.dispose();
    sellerUsernameController.dispose();
    sellerPasswordController.dispose();
    sellerConfirmPasswordController.dispose();
    sellerZipController.dispose();
    boatCityController.dispose();
    boatStateController.dispose();
    boatZipController.dispose();
    super.onClose();
  }
}
