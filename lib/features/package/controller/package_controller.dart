// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

import '../../../core/endpoints/endpoints.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/firebase/storage_service.dart';
import '../../../core/services/stripe_service.dart';
import '../model/package_model.dart';
import 'package:diaz1234567890/features/package/screen/package_screen_step1.dart';

// Engine detail model for storing multiple engines
class EngineDetail {
  final TextEditingController hoursController;
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController horsepowerController;
  final Rx<String?> fuelTypeValue;
  final Rx<String?> propellerTypeValue;

  EngineDetail({
    required this.hoursController,
    required this.makeController,
    required this.modelController,
    required this.horsepowerController,
    required this.fuelTypeValue,
    required this.propellerTypeValue,
  });

  void clear() {
    hoursController.clear();
    makeController.clear();
    modelController.clear();
    horsepowerController.clear();
    fuelTypeValue.value = null;
    propellerTypeValue.value = null;
  }

  void dispose() {
    hoursController.dispose();
    makeController.dispose();
    modelController.dispose();
    horsepowerController.dispose();
  }
}

class SellPackageController extends GetxController {
  var selectedPackage = ''.obs;
  var selectedPackageId = ''.obs;
  var packages = <PackageModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Payment and Listing Data
  var paymentIntentId = ''.obs;
  var paymentIntentClientSecret = ''.obs;
  var listingId = ''.obs;
  var userId = ''.obs;
  var accessToken = ''.obs; // Store access token after hidden login

  // Promo Code Data
  var promoCode = ''.obs;
  var promoCodeInput = TextEditingController();
  var isPromoValid = false.obs;
  var promoFreeDays = 0.obs;
  var promoErrorMessage = ''.obs;

  // Setup Intent Data (for Stripe payment)
  var setupIntentId = ''.obs;
  var setupIntentClientSecret = ''.obs;
  var planPrice = 0.0.obs;
  var planTitle = ''.obs;

  // Card Input Fields (using CardField for PCI compliance)
  var cardFieldInputDetails = Rx<CardFieldInputDetails?>(null);
  var isCardValid = false.obs;

  // Edit Mode
  var isEditMode = false.obs;
  var editingBoatId = ''.obs;
  var imagesToDelete = <String>[].obs; // Track images to delete during update

  // Helpers
  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String _getMimeType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'application/octet-stream';
    }
  }

  String _normalizeClassValue(String? value) {
    if (value == null || value.isEmpty) return '12'; // default value
    // Extract numeric part if present, otherwise return as-is
    final match = RegExp(r'(\d+)').firstMatch(value);
    return match != null ? match.group(1)! : value;
  }

  int _parseEngineCount(String? value) {
    if (value == null || value.isEmpty) return 1;
    // Handle '3+' case by extracting just the numeric part
    final match = RegExp(r'(\d+)').firstMatch(value);
    return match != null ? int.tryParse(match.group(1)!) ?? 1 : 1;
  }

  void _validateBoatDimensions() {
    // Sanitize inputs: remove non-numeric and enforce max length
    String sanitizeFeet(String text) {
      final cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
      return cleaned.length > 3 ? cleaned.substring(0, 3) : cleaned;
    }

    String sanitizeInches(String text) {
      final cleaned = text.replaceAll(RegExp(r'[^0-9]'), '');
      return cleaned.length > 2 ? cleaned.substring(0, 2) : cleaned;
    }

    final lengthFeetText = sanitizeFeet(lengthFeetController.text);
    final lengthInchesText = sanitizeInches(lengthInchesController.text);
    final beamFeetText = sanitizeFeet(beamFeetController.text);
    final beamInchesText = sanitizeInches(beamInchesController.text);
    final draftFeetText = sanitizeFeet(draftFeetController.text);
    final draftInchesText = sanitizeInches(draftInchesController.text);

    // Update controllers with sanitized values
    lengthFeetController.text = lengthFeetText;
    lengthInchesController.text = lengthInchesText;
    beamFeetController.text = beamFeetText;
    beamInchesController.text = beamInchesText;
    draftFeetController.text = draftFeetText;
    draftInchesController.text = draftInchesText;

    final lengthFeet = int.tryParse(lengthFeetText) ?? 0;
    final lengthInches = int.tryParse(lengthInchesText) ?? 0;
    final beamFeet = int.tryParse(beamFeetText) ?? 0;
    final beamInches = int.tryParse(beamInchesText) ?? 0;
    final draftFeet = int.tryParse(draftFeetText) ?? 0;
    final draftInches = int.tryParse(draftInchesText) ?? 0;

    // Length is required
    if (lengthFeet <= 0 || lengthFeet > 200) {
      throw Exception(
        'Length (feet) must be between 1 and 200 (got: $lengthFeet)',
      );
    }
    if (lengthInches < 0 || lengthInches > 11) {
      throw Exception(
        'Length (inches) must be between 0 and 11 (got: $lengthInches)',
      );
    }

    // Beam is optional - only validate if provided
    if (beamFeetText.isNotEmpty && (beamFeet <= 0 || beamFeet > 50)) {
      throw Exception('Beam (feet) must be between 1 and 50 (got: $beamFeet)');
    }
    if (beamInchesText.isNotEmpty && (beamInches < 0 || beamInches > 11)) {
      throw Exception(
        'Beam (inches) must be between 0 and 11 (got: $beamInches)',
      );
    }

    // Draft is optional - only validate if provided
    if (draftFeetText.isNotEmpty && (draftFeet < 0 || draftFeet > 30)) {
      throw Exception(
        'Draft (feet) must be between 0 and 30 (got: $draftFeet)',
      );
    }
    if (draftInchesText.isNotEmpty && (draftInches < 0 || draftInches > 11)) {
      throw Exception(
        'Draft (inches) must be between 0 and 11 (got: $draftInches)',
      );
    }
  }

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

  // Engine Controllers - Dynamic list for multiple engines
  var engines = <EngineDetail>[].obs;

  // Legacy single engine controllers (kept for edit mode compatibility)
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

  // Card Form Controller
  final cardFormEditController = CardFormEditController();

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

  // Existing images from API (for edit mode)
  var existingCoverImages = <Map<String, String>>[].obs; // List of {id, url}
  var existingGalleryImages = <Map<String, String>>[].obs; // List of {id, url}

  // Equipment arrays (for edit mode)
  var boatElectronics = <String>[].obs;
  var boatInsideEquipment = <String>[].obs;
  var boatOutsideEquipment = <String>[].obs;
  var boatElectricalEquipment = <String>[].obs;
  var boatCovers = <String>[].obs;
  var boatAdditionalEquipment = <String>[].obs;

  final List<String> year = [
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
  ];
  final List<String> make = [
    'Yamaha',
    'Sea Ray',
    'Bayliner',
    'Beneteau',
    'Mercury',
  ];
  var boatClass = <String>[].obs;
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
    _initializeEngines(value);
  }

  void _initializeEngines(String? engineCount) {
    // Clear existing engines
    for (var engine in engines) {
      engine.dispose();
    }
    engines.clear();

    // Parse engine count
    int count = 1;
    if (engineCount == '2') {
      count = 2;
    } else if (engineCount == '3+') {
      count = 3;
    }

    // Create new engine details for each engine
    for (int i = 0; i < count; i++) {
      final engine = EngineDetail(
        hoursController: TextEditingController(),
        makeController: TextEditingController(),
        modelController: TextEditingController(),
        horsepowerController: TextEditingController(),
        fuelTypeValue: RxnString(),
        propellerTypeValue: RxnString(),
      );
      engines.add(engine);
    }

    print('[DEBUG] Initialized $count engine(s)');
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
  final List<String> states = [
    'Alabama',
    'Alaska',
    'Arizona',
    'Arkansas',
    'California',
    'Colorado',
    'Connecticut',
    'Delaware',
    'Florida',
    'Georgia',
    'Hawaii',
    'Idaho',
    'Illinois',
    'Indiana',
    'Iowa',
    'Kansas',
    'Kentucky',
    'Louisiana',
    'Maine',
    'Maryland',
    'Massachusetts',
    'Michigan',
    'Minnesota',
    'Mississippi',
    'Missouri',
    'Montana',
    'Nebraska',
    'Nevada',
    'New Hampshire',
    'New Jersey',
    'New Mexico',
    'New York',
    'North Carolina',
    'North Dakota',
    'Ohio',
    'Oklahoma',
    'Ontario',
    'Oregon',
    'Pennsylvania',
    'Rhode Island',
    'South Carolina',
    'South Dakota',
    'Tennessee',
    'Texas',
    'Utah',
    'Vermont',
    'Virginia',
    'Washington',
    'West Virginia',
    'Wisconsin',
    'Wyoming',
  ];

  void selectCountry(String? value) {
    selectedCountry.value = value;
  }

  void selectCity(String? value) {
    selectedCity.value = value;
  }

  void selectState(String? value) {
    selectedState.value = value;
  }

  void clearAllControllers() {
    nameController.clear();
    priceController.clear();
    modelController.clear();
    descriptionController.clear();
    videoURLController.clear();
    lengthFeetController.clear();
    lengthInchesController.clear();
    beamFeetController.clear();
    beamInchesController.clear();
    draftFeetController.clear();
    draftInchesController.clear();
    engineHoursController.clear();
    engineMakeController.clear();
    engineModelController.clear();
    engineHorsepowerController.clear();
    sellerNameController.clear();
    sellerEmailController.clear();
    sellerUsernameController.clear();
    sellerPasswordController.clear();
    boatCityController.clear();
    boatZipController.clear();

    // Clear dynamic engines
    for (var engine in engines) {
      engine.clear();
    }
    engines.clear();

    // Clear image lists
    coverImage.value = null;
    galleryImages.clear();
    existingCoverImages.clear();
    existingGalleryImages.clear();
    imagesToDelete.clear();

    // Clear equipment lists
    boatElectronics.clear();
    boatInsideEquipment.clear();
    boatOutsideEquipment.clear();
    boatElectricalEquipment.clear();
    boatCovers.clear();
    boatAdditionalEquipment.clear();
  }

  @override
  void onInit() {
    super.onInit();
    clearAllControllers();
    fetchPackages();
    fetchBoatClasses();
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
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBoatClasses() async {
    try {
      final response = await ApiService.getBoatClasses();
      if (response['success'] == true && response['items'] != null) {
        final List<dynamic> items = response['items'];
        boatClass.value = items.map((item) => item.toString()).toList();
        print('[DEBUG] Boat classes fetched: ${boatClass.length} items loaded');
      } else {
        print(
          '[DEBUG] Failed to fetch boat classes: ${response['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      print('[DEBUG] Error fetching boat classes: $e');
    }
  }

  void selectPackage(String title) {
    selectedPackage.value = title;
    final package = packages.firstWhereOrNull((pkg) => pkg.title == title);
    if (package != null) {
      selectedPackageId.value = package.id;
    }
  }

  Future<void> applyPromoCode() async {
    try {
      final code = promoCodeInput.text.trim();

      if (code.isEmpty) {
        promoErrorMessage.value = 'Please enter a promo code';
        return;
      }

      isLoading.value = true;
      promoErrorMessage.value = '';
      isPromoValid.value = false;

      final response = await ApiService.validatePromoCode(code);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        if (data['isValid'] == true) {
          promoCode.value = code;
          promoFreeDays.value = data['freeDays'] ?? 0;
          isPromoValid.value = true;
          promoErrorMessage.value = '';

          print(
            '[DEBUG] Promo code valid: $code, Free days: ${promoFreeDays.value}',
          );

          Get.snackbar(
            'Success',
            'Promo code applied successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          promoErrorMessage.value = 'Promo code is not valid';
          isPromoValid.value = false;
        }
      } else {
        promoErrorMessage.value =
            response['message'] ?? 'Failed to validate promo code';
        isPromoValid.value = false;
      }
    } catch (e) {
      promoErrorMessage.value = e.toString().replaceFirst('Exception: ', '');
      isPromoValid.value = false;

      print('[DEBUG] Promo validation error: $e');

      Get.snackbar(
        'Error',
        promoErrorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerSellerAccount() async {
    try {
      print('[DEBUG] registerSellerAccount: Starting seller registration');
      isLoading.value = true;
      errorMessage.value = '';

      // Validate required fields
      if (sellerNameController.text.isEmpty) {
        throw Exception('Name is required');
      }
      if (sellerPhoneController.text.isEmpty) {
        throw Exception('Phone number is required');
      }
      if (sellerEmailController.text.isEmpty) {
        throw Exception('Email is required');
      }
      if (selectedCountry.value == null || selectedCountry.value!.isEmpty) {
        throw Exception('Country is required');
      }
      if (selectedCity.value == null || selectedCity.value!.isEmpty) {
        throw Exception('City is required');
      }
      if (selectedState.value == null || selectedState.value!.isEmpty) {
        throw Exception('State is required');
      }
      if (sellerZipController.text.isEmpty) {
        throw Exception('ZIP code is required');
      }
      if (sellerUsernameController.text.isEmpty) {
        throw Exception('Username is required');
      }
      if (sellerPasswordController.text.isEmpty) {
        throw Exception('Password is required');
      }
      if (sellerConfirmPasswordController.text.isEmpty) {
        throw Exception('Confirm password is required');
      }

      // Validate passwords match
      if (sellerPasswordController.text !=
          sellerConfirmPasswordController.text) {
        throw Exception('Passwords do not match');
      }

      final sellerEmail = sellerEmailController.text.trim();
      final sellerPassword = sellerPasswordController.text;

      // Call API to register seller
      final response = await ApiService.registerSellerAccount(
        name: sellerNameController.text.trim(),
        phone: sellerPhoneController.text.trim(),
        country: selectedCountry.value ?? '',
        city: selectedCity.value ?? '',
        state: selectedState.value ?? '',
        zip: sellerZipController.text.trim(),
        email: sellerEmail,
        username: sellerUsernameController.text.trim(),
        password: sellerPassword,
      );

      if (response['success'] == true) {
        print('[DEBUG] Seller registration successful: $sellerEmail');
        print('[DEBUG] Performing hidden login with email: $sellerEmail');

        // Show success message
        Get.snackbar(
          'Success',
          'Seller account created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Wait a moment for the snackbar to show
        await Future.delayed(Duration(milliseconds: 500));

        // Perform hidden login with registered credentials
        try {
          final loginResponse = await http.post(
            Uri.parse(Endpoints.login),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'email': sellerEmail,
              'password': sellerPassword,
            }),
          );

          print('[DEBUG] Login response status: ${loginResponse.statusCode}');

          if (loginResponse.statusCode == 201 ||
              loginResponse.statusCode == 200) {
            final loginData = json.decode(loginResponse.body);
            if (loginData['success'] == true) {
              final token = loginData['data']['token'];
              final userId = loginData['data']['user']['id'];

              print('[DEBUG] Hidden login successful, token received');

              // Save token and user ID
              await StorageService.saveToken(token, userId);
              accessToken.value = token;
              this.userId.value = userId;

              // Navigate to Package Selection (Step 1)
              print('[DEBUG] Navigating to PackageScreenStep1');
              Get.off(() => PackageScreenStep1());
            } else {
              throw Exception('Login failed: ${loginData['message']}');
            }
          } else {
            throw Exception(
              'Login failed with status ${loginResponse.statusCode}',
            );
          }
        } catch (loginError) {
          print('[DEBUG] Hidden login error: $loginError');
          // Even if login fails, navigate to package step - user can login manually
          Get.off(() => PackageScreenStep1());
        }
      } else {
        throw Exception(
          response['message'] ?? 'Failed to register seller account',
        );
      }
    } on SocketException catch (e) {
      Get.snackbar(
        'Network Error',
        'Check your internet connection: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('[DEBUG] Network error: $e');
    } catch (e) {
      Get.snackbar(
        'Registration Error',
        e.toString().replaceFirst('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('[DEBUG] Registration error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitBoatOnboarding() async {
    try {
      print(
        '[DEBUG] submitBoatOnboarding: Starting boat onboarding submission',
      );
      isLoading.value = true;
      errorMessage.value = '';

      final isLoggedIn = StorageService.hasToken();

      if (nameController.text.isEmpty) {
        throw Exception('Boat name is required');
      }

      if (!isLoggedIn && selectedPackageId.value.isEmpty) {
        throw Exception('Please select a package first');
      }

      // Validate common boat details for both user types
      if (boatCityController.text.trim().isEmpty) {
        throw Exception('Boat city is required');
      }
      if ((selectedBoatState.value ?? '').trim().isEmpty) {
        throw Exception('Boat state is required');
      }

      // Zip must be numeric
      final zip = boatZipController.text.trim();
      if (zip.isEmpty || !RegExp(r'^\d{3,10}$').hasMatch(zip)) {
        throw Exception('Boat ZIP/postal code must be numeric (3-10 digits)');
      }

      // Build year sanity check
      final currentYear = DateTime.now().year;
      final buildYear = int.tryParse(selectedBuildYear.value ?? '') ?? 0;
      if (buildYear < 1900 || buildYear > currentYear) {
        throw Exception('Build year must be between 1900 and $currentYear');
      }

      // Price must be positive
      final priceVal = double.tryParse(priceController.text) ?? 0.0;
      if (priceVal <= 0) {
        throw Exception('Price must be greater than 0');
      }

      // Video URL optional but if provided should be valid
      if (videoURLController.text.trim().isNotEmpty &&
          !_isValidUrl(videoURLController.text.trim())) {
        throw Exception('Video URL must start with http or https');
      }

      // Dimensions validation
      _validateBoatDimensions();

      // Cover image is required
      if (coverImage.value == null && existingCoverImages.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Cover image is required',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // If user is not logged in, check if seller information is filled
      if (!isLoggedIn) {
        // If seller email is empty, user hasn't filled Step 3 yet - navigate there
        if (sellerEmailController.text.isEmpty) {
          print(
            '[DEBUG] Non-logged-in user: navigating to Step 3 for seller information',
          );
          isLoading.value = false;
          Get.toNamed('/sellPackageScreen');
          return;
        }

        // Seller email is filled, validate remaining seller info before submission
        if (sellerNameController.text.isEmpty) {
          throw Exception('Seller name is required');
        }
        if (sellerPhoneController.text.isEmpty) {
          throw Exception('Seller phone is required');
        }
        if (sellerUsernameController.text.isEmpty) {
          throw Exception('Seller username is required');
        }
        if (sellerPasswordController.text.isEmpty) {
          throw Exception('Seller password is required');
        }
        if (selectedCountry.value == null || selectedCountry.value!.isEmpty) {
          throw Exception('Country is required');
        }
        if (selectedCity.value == null || selectedCity.value!.isEmpty) {
          throw Exception('City is required');
        }
        if (selectedState.value == null || selectedState.value!.isEmpty) {
          throw Exception('State is required');
        }

        print(
          '[DEBUG] All seller information is complete. Proceeding with submission...',
        );
      }

      // For logged-in users or non-logged-in users with complete seller info, proceed with submission

      // Build boat info
      final boatInfo = {
        'name': nameController.text,
        'price': priceVal,
        'model': modelController.text,
        'make': selectedMake.value ?? '',
        'buildYear': buildYear,
        'boatClass': _normalizeClassValue(selectedClass.value),
        'material': selectedMaterial.value ?? '',
        'fuelType': selectedFuelType.value ?? '',
        'condition': selectedCondition.value ?? 'Used',
        'engineType': selectedEngineType.value ?? '',
        'propType': selectedPropType.value ?? '',
        'propMaterial': selectedPropMaterial.value ?? '',
        'enginesNumber': _parseEngineCount(selectedNumberOfEngine.value),
        'cabinsNumber': _parseEngineCount(selectedNumberOfCabin.value),
        'headsNumber': _parseEngineCount(selectedNumberOfHeads.value),
        'description': descriptionController.text,
        'videoURL': videoURLController.text,
        'city': boatCityController.text.trim(),
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
        'engines': engines.isEmpty
            ? [
                {
                  'hours': int.tryParse(engineHoursController.text) ?? 0,
                  'horsepower':
                      int.tryParse(engineHorsepowerController.text) ?? 0,
                  'make': engineMakeController.text,
                  'model': engineModelController.text,
                  'fuelType': selectedEngineFuelType.value ?? '',
                  'propellerType': selectedPropellerType.value ?? '',
                },
              ]
            : engines.map((engine) {
                return {
                  'hours': int.tryParse(engine.hoursController.text) ?? 0,
                  'horsepower':
                      int.tryParse(engine.horsepowerController.text) ?? 0,
                  'make': engine.makeController.text,
                  'model': engine.modelController.text,
                  'fuelType': engine.fuelTypeValue.value ?? '',
                  'propellerType': engine.propellerTypeValue.value ?? '',
                };
              }).toList(),
        'electronics': <String>[],
        'electricalEquipment': <String>[],
        'insideEquipment': <String>[],
        'outsideEquipment': <String>[],
        'covers': <String>[],
        'additionalEquipment': <String>[],
        'extraDetails':
            <
              Map<String, dynamic>
            >[], // Changed to dynamic for proper JSON encoding
      };

      // Prepare file paths separately
      final List<String> coverPaths = coverImage.value != null
          ? [coverImage.value!.path]
          : [];
      final List<String> galleryPaths = galleryImages
          .map((image) => image.path)
          .toList();

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

      print('\n[DEBUG] ========== Submitting Boat Onboarding ==========');
      print('[DEBUG] Boat Info: $boatInfo');
      print('[DEBUG] Seller Info: $sellerInfo');
      print('[DEBUG] Plan ID: ${selectedPackageId.value}');
      print('[DEBUG] Cover Images: $coverPaths');
      print('[DEBUG] Gallery Images: $galleryPaths');
      print('[DEBUG] =========================================\n');

      // Determine which endpoint to use
      bool useOnboardingEndpoint = !isLoggedIn;
      String planIdToUse = selectedPackageId.value;

      // If user is logged in, check if they have an active subscription
      if (isLoggedIn) {
        try {
          print('[DEBUG] User is logged in. Checking subscription status...');
          final profileResponse = await ApiService.getUserProfile();

          if (profileResponse['success'] == true) {
            final profileData = profileResponse['data'];
            final currentPlanId = profileData['currentPlanId'];

            print('[DEBUG] currentPlanId: $currentPlanId');

            // If no active subscription, use onboarding endpoint
            if (currentPlanId == null || currentPlanId.toString().isEmpty) {
              print(
                '[DEBUG] No active subscription. Using onboarding endpoint.',
              );
              useOnboardingEndpoint = true;
              // Need to get seller info from controllers for onboarding submission
              // This is a newly registered seller without subscription
            } else {
              print(
                '[DEBUG] User has active subscription. Using create-listing endpoint.',
              );
              useOnboardingEndpoint = false;
              planIdToUse = ''; // Empty planId for authenticated users
            }
          }
        } catch (e) {
          print('[DEBUG] Error checking subscription status: $e');
          // Default to subscription-required endpoint if check fails
          useOnboardingEndpoint = false;
          planIdToUse = '';
        }
      }

      // Try simple JSON approach first (without file uploads)
      print('[DEBUG] Attempting submission without file uploads first...');
      try {
        final response = useOnboardingEndpoint
            ? await ApiService.createBoatOnboardingSimple(
                boatInfo: boatInfo,
                sellerInfo: sellerInfo,
                planId: planIdToUse,
                isNewSeller:
                    !isLoggedIn, // Only send sellerInfo for non-logged-in users
                promoCode: promoCode.value,
              )
            : await ApiService.createListing(
                boatInfo: boatInfo,
                planId: planIdToUse,
              );

        print('[DEBUG] submitBoatOnboarding: Response received - $response');

        if (response['success'] == true) {
          // Store listing and payment data from response
          final data = response['data'];
          if (data != null) {
            // Extract listing ID from listingPreview (nested structure)
            final listingPreview = data['listingPreview'];
            if (listingPreview != null) {
              listingId.value =
                  listingPreview['listingId'] ?? listingPreview['id'] ?? '';
              userId.value = listingPreview['userId'] ?? '';
            } else {
              // Fallback for different response structure
              listingId.value = data['listingId'] ?? data['id'] ?? '';
              userId.value = data['userId'] ?? '';
            }

            print('\n=== Listing Created Successfully ===');
            print('Listing ID: ${listingId.value}');
            print('User ID: ${userId.value}');
            print('====================================\n');
          }

          Get.snackbar(
            'Success',
            'Boat listing created successfully! Listing ID: ${listingId.value}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Only perform hidden login if user is NOT already logged in
          if (!isLoggedIn) {
            await performHiddenLogin(
              email: sellerEmailController.text.trim(),
              password: sellerPasswordController.text,
            );
          }

          // Fetch setup intent for payment before navigating to Step 4
          // If user already has an active subscription, this will fail gracefully
          print('[DEBUG] Fetching setup intent for payment...');
          try {
            await fetchSetupIntentForPayment();
          } catch (setupIntentError) {
            final errorMsg = setupIntentError.toString();
            if (errorMsg.contains('already has an active subscription')) {
              print(
                '[DEBUG] User already has active subscription - skipping payment',
              );
              Get.snackbar(
                'Info',
                'You already have an active subscription. Your listing is now live!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.blue,
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
              );
            } else {
              print('[DEBUG] Setup intent error: $setupIntentError');
              // Show error but still navigate - user can retry payment later
              Get.snackbar(
                'Payment Note',
                'Listing created but payment couldn\'t be initialized. Please try again.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
            }
          }

          // Navigate to product based on subscription status
          Future.delayed(Duration(seconds: 2), () {
            // Go to payment if user is new or doesn't have subscription
            if (!isLoggedIn || useOnboardingEndpoint) {
              print('[DEBUG] User needs payment setup. Going to Step 4...');
              Get.toNamed('/packageScreenStep4');
            } else {
              // User has active subscription - go to home
              print('[DEBUG] User has subscription. Going to home...');
              Get.offAllNamed('/bottomNavBar');
            }
          });

          return;
        } else {
          errorMessage.value =
              response['message'] ?? 'Failed to create listing';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      } catch (e) {
        print('[DEBUG] Simple submission failed: $e');
        print(
          '[DEBUG] Note: Listing created without images. Files may need separate upload endpoint.',
        );

        // Don't try multipart if simple JSON succeeded with payment intent
        if (paymentIntentId.value.isNotEmpty) {
          Get.snackbar(
            'Note',
            'Listing created but images need to be uploaded separately',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        print('[DEBUG] Trying with file uploads...');
      }

      // If simple approach fails or doesn't work, try with files
      final response = useOnboardingEndpoint
          ? await ApiService.createBoatOnboarding(
              boatInfo: boatInfo,
              sellerInfo: sellerInfo,
              planId: planIdToUse,
              coverPaths: coverPaths,
              galleryPaths: galleryPaths,
              isNewSeller:
                  !isLoggedIn, // Only send sellerInfo for non-logged-in users
              promoCode: promoCode.value,
            )
          : await ApiService.createListingWithFiles(
              boatInfo: boatInfo,
              planId: planIdToUse,
              coverPaths: coverPaths,
              galleryPaths: galleryPaths,
            );

      print('[DEBUG] submitBoatOnboarding: File upload response - $response');

      if (response['success'] == true) {
        // Store listing and payment data from response
        final data = response['data'];
        if (data != null) {
          // Extract listing ID from listingPreview (nested structure)
          final listingPreview = data['listingPreview'];
          if (listingPreview != null) {
            listingId.value =
                listingPreview['listingId'] ?? listingPreview['id'] ?? '';
            userId.value = listingPreview['userId'] ?? '';
          } else {
            // Fallback for different response structure
            listingId.value = data['listingId'] ?? data['id'] ?? '';
            userId.value = data['userId'] ?? '';
          }

          print('\n=== Listing Created Successfully ===');
          print('Listing ID: ${listingId.value}');
          print('User ID: ${userId.value}');
          print('====================================\n');
        }

        Get.snackbar(
          'Success',
          'Boat listing created successfully! Listing ID: ${listingId.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Only perform hidden login if user is NOT already logged in
        if (!isLoggedIn) {
          await performHiddenLogin(
            email: sellerEmailController.text.trim(),
            password: sellerPasswordController.text,
          );

          // Fetch setup intent for payment before navigating to Step 4 (only for new users)
          print('[DEBUG] Fetching setup intent for payment...');
          await fetchSetupIntentForPayment();

          // Navigate to Step 4 (payment section)
          Future.delayed(Duration(seconds: 1), () {
            Get.toNamed('/packageScreenStep4');
          });
        } else {
          // For logged-in users, check if they need to set up payment
          if (useOnboardingEndpoint) {
            // No active subscription - fetch setup intent and go to payment
            print(
              '[DEBUG] Logged-in user without subscription. Going to payment setup...',
            );
            try {
              await fetchSetupIntentForPayment();
            } catch (e) {
              print('[DEBUG] Error fetching setup intent: $e');
            }

            Future.delayed(Duration(seconds: 1), () {
              Get.toNamed('/packageScreenStep4');
            });
          } else {
            // Has active subscription - go to home
            print('[DEBUG] Logged-in user with subscription. Going to home...');
            Future.delayed(Duration(seconds: 1), () {
              Get.offAllNamed('/bottomNavBar');
            });
          }
        }
      } else {
        errorMessage.value = response['message'] ?? 'Failed to create listing';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Error submitting boat listing: $e';
      print('[DEBUG] submitBoatOnboarding: Error - $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
      print('[DEBUG] submitBoatOnboarding: Completed, isLoading = false');
    }
  }

  Future<void> performHiddenLogin({
    required String email,
    required String password,
  }) async {
    try {
      if (!StorageService.isInitialized) {
        await StorageService.init();
      }

      final response = await ApiService.login(email: email, password: password);

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        final String userId = userData['id'];
        final String token = response['data']['token'];

        await StorageService.saveToken(token, userId);

        accessToken.value = token;
        this.userId.value = userId;

        await fetchSetupIntentForPayment();
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch setup intent data from backend for Stripe payment
  Future<void> fetchSetupIntentForPayment() async {
    try {
      final response = await ApiService.getSetupIntent(selectedPackageId.value);

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        setupIntentId.value = data['setupIntentId'] ?? '';
        setupIntentClientSecret.value = data['setupIntentSecret'] ?? '';
        planPrice.value = (data['amount'] ?? 0).toDouble();
        planTitle.value = data['planTitle'] ?? '';
      } else {
        throw Exception('Failed to fetch setup intent: ${response['message']}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loginAndNavigate() async {
    print('[DEBUG] loginAndNavigate: Starting login process');
    try {
      // Validate login fields
      if (sellerEmailController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Email is required for login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (sellerPasswordController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Password is required for login',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      errorMessage.value = '';

      print('[DEBUG] loginAndNavigate: Calling login API');
      // Call login API
      final response = await ApiService.login(
        email: sellerEmailController.text,
        password: sellerPasswordController.text,
      );

      if (response['success'] == true) {
        print('[DEBUG] loginAndNavigate: Login successful');
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to next screen after successful login
        print('[DEBUG] loginAndNavigate: Navigating to packageScreenStep4');
        Get.toNamed('/packageScreenStep4');
      } else {
        errorMessage.value =
            response['message'] ?? 'Login failed. Please try again.';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Login error: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('[DEBUG] loginAndNavigate: Login error - $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> confirmPayment() async {
    print('[DEBUG] confirmPayment: Starting payment confirmation');
    try {
      // Check for user data
      if (userId.value.isEmpty) {
        throw Exception(
          'User ID not available. Please ensure login was successful.',
        );
      }

      final cardDetails = cardFormEditController.details;

      if (cardDetails.brand == null) {
        throw Exception('Please enter a valid card number.');
      }

      isLoading.value = true;
      errorMessage.value = '';

      await fetchSetupIntentForPayment();

      // Verify we have a valid setup intent
      if (setupIntentClientSecret.value.isEmpty) {
        throw Exception('Failed to initialize payment. Please try again.');
      }

      if (setupIntentId.value.isEmpty) {
        throw Exception(
          'Setup Intent ID not available. Please ensure setup intent was created.',
        );
      }

      print('═══════════════════════════════════════════════════════');
      print('💳 STRIPE PAYMENT PROCESSING');
      print('═══════════════════════════════════════════════════════');
      print('User ID: ${userId.value}');
      print('Setup Intent ID: ${setupIntentId.value}');
      print('Plan Price: \$${planPrice.value.toStringAsFixed(2)}');
      print('Plan Title: ${planTitle.value}');
      print('Card is complete: ${cardDetails.complete}');
      print('═══════════════════════════════════════════════════════\n');

      // Confirm setup intent with Stripe using CardField data
      final stripeSuccess = await StripeService.confirmSetupIntent(
        clientSecret: setupIntentClientSecret.value,
        cardFieldDetails: cardDetails,
      );

      if (stripeSuccess) {
        print('\n✅ SETUP INTENT CONFIRMED WITH STRIPE SUCCESSFULLY\n');
        Get.snackbar(
          'Success',
          'Payment processed! Your subscription is now being activated.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Clear card fields after successful payment
        // The card form will remain visible but the controller can be reused

        // Clear setup intent so it can't be reused
        setupIntentId.value = '';
        setupIntentClientSecret.value = '';

        // Give a moment for the backend to process the payment
        await Future.delayed(const Duration(seconds: 2));

        // Fetch subscription confirmation from backend
        print('[DEBUG] confirmPayment: Fetching subscription confirmation');
        await fetchSubscriptionConfirmation();
      } else {
        errorMessage.value =
            'Setup intent confirmation failed. Please try again.';
        print('\n❌ Setup intent confirmation failed: ${errorMessage.value}\n');
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage.value = '$e';
      print('\n❌ Payment error: $e\n');
      Get.snackbar(
        'Error',
        errorMessage.value.isNotEmpty ? errorMessage.value : 'Payment failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSubscriptionConfirmation() async {
    print('[DEBUG] fetchSubscriptionConfirmation: Starting');
    try {
      final userIdValue = userId.value;

      if (userIdValue.isEmpty) {
        throw Exception(
          'User ID is not available. Onboarding may have failed.',
        );
      }

      isLoading.value = true;
      errorMessage.value = '';

      print(
        '[DEBUG] fetchSubscriptionConfirmation: Fetching confirmation for User ID = $userIdValue',
      );

      final response = await ApiService.getSubscriptionConfirmation(
        userId: userIdValue,
      );

      print('[DEBUG] fetchSubscriptionConfirmation: Response - $response');

      if (response != null && response['success'] == true) {
        Get.snackbar(
          'Success',
          'Subscription activated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home screen after snackbar is shown
        print(
          '[DEBUG] fetchSubscriptionConfirmation: Navigation - Going to home screen',
        );
        await Future.delayed(Duration(seconds: 2));

        // Clear the loading state before navigation
        isLoading.value = false;

        try {
          // Navigate to bottom nav bar (home screen)
          await Get.offAllNamed('/bottomNavBar');
          print(
            '[DEBUG] fetchSubscriptionConfirmation: Successfully navigated to home',
          );
        } catch (navError) {
          print(
            '[DEBUG] fetchSubscriptionConfirmation: Navigation error - $navError',
          );
        }
      } else {
        errorMessage.value =
            response?['message'] ?? 'Subscription not yet confirmed';
        print('[DEBUG] fetchSubscriptionConfirmation: Not confirmed yet');
        Get.snackbar(
          'Info',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      errorMessage.value = 'Error fetching confirmation: $e';
      print('[DEBUG] fetchSubscriptionConfirmation: Error - $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch boat details for editing
  Future<void> fetchBoatDetailsForEdit(String boatId) async {
    try {
      print(
        '[DEBUG] fetchBoatDetailsForEdit: Starting to fetch boat ID: $boatId',
      );
      isLoading.value = true;
      errorMessage.value = '';

      final token = StorageService.token;
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final uri = Uri.parse(Endpoints.getBoatById(boatId));
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        print('[DEBUG] Boat details response: ${response.body}');

        if (jsonBody['success'] == true && jsonBody['data'] is Map) {
          final boatData = jsonBody['data'] as Map<String, dynamic>;
          populateFormFromBoatData(boatData);
          editingBoatId.value = boatId;
          isEditMode.value = true;
          print('[DEBUG] Boat details loaded and form populated for editing');
        } else {
          errorMessage.value =
              jsonBody['message']?.toString() ?? 'Failed to load boat details';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Failed to load boat (${response.statusCode})';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      print('[DEBUG] fetchBoatDetailsForEdit: Error - $e');
      Get.snackbar(
        'Error',
        'Failed to load boat details: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate form fields from boat data
  void populateFormFromBoatData(Map<String, dynamic> data) {
    try {
      // Basic Info
      nameController.text = data['name'] ?? '';
      priceController.text = (data['price'] ?? 0).toString();
      modelController.text = data['model'] ?? '';
      descriptionController.text = data['description'] ?? '';
      videoURLController.text = data['videoURL'] ?? '';

      // Dimensions
      final dimensions = data['boatDimensions'] as Map<String, dynamic>?;
      if (dimensions != null) {
        lengthFeetController.text = (dimensions['lengthFeet'] ?? 0).toString();
        lengthInchesController.text = (dimensions['lengthInches'] ?? 0)
            .toString();
        beamFeetController.text = (dimensions['beamFeet'] ?? 0).toString();
        beamInchesController.text = (dimensions['beamInches'] ?? 0).toString();
        draftFeetController.text = (dimensions['draftFeet'] ?? 0).toString();
        draftInchesController.text = (dimensions['draftInches'] ?? 0)
            .toString();
      }

      // Specifications
      selectedBuildYear.value = (data['buildYear'] ?? '').toString();
      selectedMake.value = data['make'];
      selectedClass.value = data['class'];
      selectedMaterial.value = data['material'];
      selectedFuelType.value = data['fuelType'];
      selectedCondition.value = data['condition'];
      selectedEngineType.value = data['engineType'];
      selectedPropType.value = data['propType'];
      selectedPropMaterial.value = data['propMaterial'];
      selectedNumberOfEngine.value = (data['enginesNumber'] ?? 1).toString();
      selectedNumberOfCabin.value = (data['cabinsNumber'] ?? 1).toString();
      selectedNumberOfHeads.value = (data['headsNumber'] ?? 1).toString();

      // Location
      boatCityController.text = data['city'] ?? '';
      selectedBoatState.value = data['state'];
      boatZipController.text = data['zip'] ?? '';

      // Engine Info
      final engines = data['engines'] as List<dynamic>?;
      if (engines != null && engines.isNotEmpty) {
        final engine = engines[0] as Map<String, dynamic>;
        engineHoursController.text = (engine['hours'] ?? 0).toString();
        engineMakeController.text = engine['make'] ?? '';
        engineModelController.text = engine['model'] ?? '';
        engineHorsepowerController.text = (engine['horsepower'] ?? 0)
            .toString();
        selectedEngineFuelType.value = engine['fuelType'];
        selectedPropellerType.value = engine['propellerType'];
      }

      // Load existing images from API response
      existingCoverImages.clear();
      existingGalleryImages.clear();

      // Try multiple field names for cover images
      final coverImages =
          (data['coverImages'] ??
                  data['cover_images'] ??
                  data['covers'] ??
                  data['images'])
              as List<dynamic>?;

      if (coverImages != null && coverImages.isNotEmpty) {
        for (final img in coverImages) {
          if (img is Map<String, dynamic>) {
            final imageUrl = img['url'] as String?;
            final imageId = img['id'] as String?;
            if (imageUrl != null && imageUrl.isNotEmpty && imageId != null) {
              existingCoverImages.add({'id': imageId, 'url': imageUrl});
              print('[DEBUG] Loaded cover image: $imageUrl');
            }
          }
        }
      }

      // Try multiple field names for gallery images
      final galleryImgs =
          (data['galleryImages'] ??
                  data['gallery_images'] ??
                  data['photos'] ??
                  (data['images'] is List &&
                          (data['coverImages'] != null ||
                              data['covers'] != null)
                      ? []
                      : null))
              as List<dynamic>?;

      if (galleryImgs != null && galleryImgs.isNotEmpty) {
        for (final img in galleryImgs) {
          if (img is Map<String, dynamic>) {
            final imageUrl = img['url'] as String?;
            final imageId = img['id'] as String?;
            if (imageUrl != null && imageUrl.isNotEmpty && imageId != null) {
              existingGalleryImages.add({'id': imageId, 'url': imageUrl});
              print('[DEBUG] Loaded gallery image: $imageUrl');
            }
          }
        }
      }

      // Load equipment arrays
      final electronics =
          (data['electronics'] as List<dynamic>?)?.cast<String>() ?? [];
      final insideEquipment =
          (data['insideEquipment'] as List<dynamic>?)?.cast<String>() ?? [];
      final outsideEquipment =
          (data['outsideEquipment'] as List<dynamic>?)?.cast<String>() ?? [];
      final electricalEquipment =
          (data['electricalEquipment'] as List<dynamic>?)?.cast<String>() ?? [];
      final covers = (data['covers'] as List<dynamic>?)?.cast<String>() ?? [];
      final additionalEquipment =
          (data['additionalEquipment'] as List<dynamic>?)?.cast<String>() ?? [];

      boatElectronics.assignAll(electronics);
      boatInsideEquipment.assignAll(insideEquipment);
      boatOutsideEquipment.assignAll(outsideEquipment);
      boatElectricalEquipment.assignAll(electricalEquipment);
      boatCovers.assignAll(covers);
      boatAdditionalEquipment.assignAll(additionalEquipment);

      print('[DEBUG] Form populated successfully from boat data');
      print(
        '[DEBUG] Loaded ${existingCoverImages.length} cover images and ${existingGalleryImages.length} gallery images',
      );
    } catch (e) {
      print('[DEBUG] Error populating form: $e');
      Get.snackbar(
        'Warning',
        'Some fields could not be loaded',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  /// Update boat listing
  Future<void> updateBoatListing() async {
    try {
      print(
        '[DEBUG] updateBoatListing: Starting update for boat ID: ${editingBoatId.value}',
      );
      isLoading.value = true;
      errorMessage.value = '';

      // Validate required fields
      if (nameController.text.isEmpty) {
        throw Exception('Boat name is required');
      }
      if (boatCityController.text.trim().isEmpty) {
        throw Exception('Boat city is required');
      }
      if ((selectedBoatState.value ?? '').trim().isEmpty) {
        throw Exception('Boat state is required');
      }

      final zip = boatZipController.text.trim();
      if (zip.isEmpty || !RegExp(r'^\d{3,10}$').hasMatch(zip)) {
        throw Exception('Boat ZIP/postal code must be numeric (3-10 digits)');
      }

      final priceVal = double.tryParse(priceController.text) ?? 0.0;
      if (priceVal <= 0) {
        throw Exception('Price must be greater than 0');
      }

      if (videoURLController.text.trim().isNotEmpty &&
          !_isValidUrl(videoURLController.text.trim())) {
        throw Exception('Video URL must start with http or https');
      }

      _validateBoatDimensions();

      // Build boat info
      final boatInfo = {
        'name': nameController.text,
        'price': priceVal,
        'model': modelController.text,
        'make': selectedMake.value ?? '',
        'buildYear': int.tryParse(selectedBuildYear.value ?? '') ?? 0,
        'boatClass': _normalizeClassValue(selectedClass.value),
        'material': selectedMaterial.value ?? '',
        'fuelType': selectedFuelType.value ?? '',
        'condition': selectedCondition.value ?? 'Used',
        'engineType': selectedEngineType.value ?? '',
        'propType': selectedPropType.value ?? '',
        'propMaterial': selectedPropMaterial.value ?? '',
        'enginesNumber': _parseEngineCount(selectedNumberOfEngine.value),
        'cabinsNumber': _parseEngineCount(selectedNumberOfCabin.value),
        'headsNumber': _parseEngineCount(selectedNumberOfHeads.value),
        'description': descriptionController.text,
        'videoURL': videoURLController.text,
        'city': boatCityController.text.trim(),
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
        'engines': engines.isEmpty
            ? [
                {
                  'hours': int.tryParse(engineHoursController.text) ?? 0,
                  'horsepower':
                      int.tryParse(engineHorsepowerController.text) ?? 0,
                  'make': engineMakeController.text,
                  'model': engineModelController.text,
                  'fuelType': selectedEngineFuelType.value ?? '',
                  'propellerType': selectedPropellerType.value ?? '',
                },
              ]
            : engines.map((engine) {
                return {
                  'hours': int.tryParse(engine.hoursController.text) ?? 0,
                  'horsepower':
                      int.tryParse(engine.horsepowerController.text) ?? 0,
                  'make': engine.makeController.text,
                  'model': engine.modelController.text,
                  'fuelType': engine.fuelTypeValue.value ?? '',
                  'propellerType': engine.propellerTypeValue.value ?? '',
                };
              }).toList(),
        'electronics': boatElectronics.toList(),
        'electricalEquipment': boatElectricalEquipment.toList(),
        'insideEquipment': boatInsideEquipment.toList(),
        'outsideEquipment': boatOutsideEquipment.toList(),
        'covers': boatCovers.toList(),
        'additionalEquipment': boatAdditionalEquipment.toList(),
        'extraDetails': <Map<String, dynamic>>[],
        'imagesToDelete': imagesToDelete.toList(),
      };

      // Prepare file paths
      final List<String> coverPaths = coverImage.value != null
          ? [coverImage.value!.path]
          : [];
      final List<String> galleryPaths = galleryImages
          .map((image) => image.path)
          .toList();

      print('[DEBUG] Boat Info: $boatInfo');
      print('[DEBUG] Equipment Status:');
      print('[DEBUG]   - Electronics: ${boatElectronics.toList()}');
      print('[DEBUG]   - Inside Equipment: ${boatInsideEquipment.toList()}');
      print('[DEBUG]   - Outside Equipment: ${boatOutsideEquipment.toList()}');
      print(
        '[DEBUG]   - Electrical Equipment: ${boatElectricalEquipment.toList()}',
      );
      print('[DEBUG]   - Covers: ${boatCovers.toList()}');
      print(
        '[DEBUG]   - Additional Equipment: ${boatAdditionalEquipment.toList()}',
      );
      print('[DEBUG] New Cover Images: $coverPaths');
      print('[DEBUG] New Gallery Images: $galleryPaths');
      print(
        '[DEBUG] Existing Cover Images: ${existingCoverImages.map((img) => img['url']).toList()}',
      );
      print(
        '[DEBUG] Existing Gallery Images: ${existingGalleryImages.map((img) => img['url']).toList()}',
      );
      print('[DEBUG] Images to Delete: ${imagesToDelete.toList()}');

      // Make PATCH request as multipart/form-data
      final token = StorageService.token;
      final uri = Uri.parse(Endpoints.updateListing(editingBoatId.value));

      print('[DEBUG] PATCH Request to: $uri');

      // Create multipart request
      final request = http.MultipartRequest('PATCH', uri);

      // Add authorization header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add boatInfo as JSON string field
      request.fields['boatInfo'] = jsonEncode(boatInfo);

      // Add covers (actual file uploads using ByteStream)
      for (int i = 0; i < coverPaths.length; i++) {
        try {
          final file = File(coverPaths[i]);
          if (await file.exists()) {
            final fileSize = await file.length();
            final filename = coverPaths[i].split('/').last;
            final mimeType = _getMimeType(filename);

            print(
              '[DEBUG] Adding cover file: $filename (mime: $mimeType, size: $fileSize)',
            );

            final stream = http.ByteStream(file.openRead());
            final multipartFile = http.MultipartFile(
              'covers',
              stream,
              fileSize,
              filename: filename,
              contentType: MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);
          } else {
            print('[DEBUG] Cover file not found: ${coverPaths[i]}');
          }
        } catch (e) {
          print('[DEBUG] Error reading cover file: $e');
        }
      }

      // Add galleries (actual file uploads using ByteStream)
      for (int i = 0; i < galleryPaths.length; i++) {
        try {
          final file = File(galleryPaths[i]);
          if (await file.exists()) {
            final fileSize = await file.length();
            final filename = galleryPaths[i].split('/').last;
            final mimeType = _getMimeType(filename);

            print(
              '[DEBUG] Adding gallery file: $filename (mime: $mimeType, size: $fileSize)',
            );

            final stream = http.ByteStream(file.openRead());
            final multipartFile = http.MultipartFile(
              'galleries',
              stream,
              fileSize,
              filename: filename,
              contentType: MediaType.parse(mimeType),
            );
            request.files.add(multipartFile);
          } else {
            print('[DEBUG] Gallery file not found: ${galleryPaths[i]}');
          }
        } catch (e) {
          print('[DEBUG] Error reading gallery file: $e');
        }
      }

      print('[DEBUG] Total files to upload: ${request.files.length}');
      print(
        '[DEBUG] Cover files: ${coverPaths.length}, Gallery files: ${galleryPaths.length}',
      );

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      print('[DEBUG] Update response status: ${response.statusCode}');
      print('[DEBUG] Update response body: $responseString');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(responseString);

        if (jsonBody['success'] == true) {
          Get.snackbar(
            'Success',
            'Boat listing updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

          // Navigate back to my listings
          Future.delayed(Duration(seconds: 1), () {
            Get.offAllNamed('/bottomNavBar');
          });
        } else {
          errorMessage.value =
              jsonBody['message']?.toString() ?? 'Failed to update listing';
          Get.snackbar(
            'Error',
            errorMessage.value,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        errorMessage.value = 'Failed to update boat (${response.statusCode})';
        Get.snackbar(
          'Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      errorMessage.value = 'Error updating boat listing: $e';
      print('[DEBUG] updateBoatListing: Error - $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
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
    cardFormEditController.dispose();
    boatCityController.dispose();
    boatStateController.dispose();
    boatZipController.dispose();

    // Dispose dynamic engines
    for (var engine in engines) {
      engine.dispose();
    }

    super.onClose();
  }
}
