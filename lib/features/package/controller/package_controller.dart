// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/services/api_service.dart';
import '../../../core/services/firebase/storage_service.dart';
import '../../../core/services/stripe_service.dart';
import '../model/package_model.dart';

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

  // Setup Intent Data (for Stripe payment)
  var setupIntentId = ''.obs;
  var setupIntentClientSecret = ''.obs;
  var planPrice = 0.0.obs;
  var planTitle = ''.obs;

  // Card Input Fields (using CardField for PCI compliance)
  var cardFieldInputDetails = Rx<CardFieldInputDetails?>(null);
  var isCardValid = false.obs;

  // Helpers
  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String _normalizeClassValue(String? value) {
    if (value == null || value.isEmpty) return '12'; // default value
    // Extract numeric part if present, otherwise return as-is
    final match = RegExp(r'(\d+)').firstMatch(value);
    return match != null ? match.group(1)! : value;
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

    if (lengthFeet <= 0 || lengthFeet > 200) {
      throw Exception(
        'Length (feet) must be between 1 and 200 (got: $lengthFeet)',
      );
    }
    if (beamFeet <= 0 || beamFeet > 50) {
      throw Exception('Beam (feet) must be between 1 and 50 (got: $beamFeet)');
    }
    if (draftFeet < 0 || draftFeet > 30) {
      throw Exception(
        'Draft (feet) must be between 0 and 30 (got: $draftFeet)',
      );
    }
    if (lengthInches < 0 || lengthInches > 11) {
      throw Exception(
        'Length (inches) must be between 0 and 11 (got: $lengthInches)',
      );
    }
    if (beamInches < 0 || beamInches > 11) {
      throw Exception(
        'Beam (inches) must be between 0 and 11 (got: $beamInches)',
      );
    }
    if (draftInches < 0 || draftInches > 11) {
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
  final List<String> boatClass = ['12', '14', '16', '18', '20', '22', '24'];
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
  }

  void prefillTestData() {
    // Boat Info
    nameController.text = 'Sapphire';
    priceController.text = '125000.5';
    modelController.text = 'Oceanis 38';
    descriptionController.text = 'Beautiful yacht with all amenities';
    videoURLController.text = 'https://www.youtube.com/watch?v=8eZu8K5W0mM';

    // Dimensions
    lengthFeetController.text = '36';
    lengthInchesController.text = '6';
    beamFeetController.text = '12';
    beamInchesController.text = '6';
    draftFeetController.text = '3';
    draftInchesController.text = '2';

    // Engine Info
    engineHoursController.text = '1200';
    engineMakeController.text = 'Mercury';
    engineModelController.text = 'Verado 350';
    engineHorsepowerController.text = '350';

    // Location
    boatCityController.text = 'Miami';
    boatZipController.text = '33101';

    // Seller Info - Use unique values to avoid duplicate user errors
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    sellerNameController.text = 'John Doe';
    sellerEmailController.text = 'seller$timestamp@example.com';
    sellerUsernameController.text = 'seller_$timestamp';
    sellerPasswordController.text = 'strongPassword123!';
    sellerZipController.text = '33101';
    sellerPhoneController.text = '+1234567890';

    // Dropdown selections
    selectedBuildYear.value = '2018';
    selectedMake.value = 'Beneteau';
    selectedClass.value = '12';
    selectedMaterial.value = 'Aluminium';
    selectedFuelType.value = 'Mercury';
    selectedCondition.value = 'New';
    selectedEngineType.value = 'Propeller';
    selectedPropType.value = 'Propeller';
    selectedPropMaterial.value = 'Aluminium';
    selectedNumberOfEngine.value = '2';
    selectedNumberOfCabin.value = '3';
    selectedNumberOfHeads.value = '2';
    selectedBoatState.value = 'Florida';
    selectedEngineFuelType.value = 'Mercury';
    selectedPropellerType.value = '12';
    selectedCountry.value = 'USA';
    selectedCity.value = 'New York';
    selectedState.value = 'Florida';
  }

  @override
  void onInit() {
    print('[DEBUG] SellPackageController: onInit called');
    super.onInit();
    clearAllControllers();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      print('[DEBUG] fetchPackages: Starting to fetch packages');
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiService.getSubscriptionPlans();
      print('[DEBUG] fetchPackages: API Response received - $response');

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        packages.value = data
            .map((item) => PackageModel.fromJson(item as Map<String, dynamic>))
            .toList();
        print('[DEBUG] fetchPackages: Loaded ${packages.length} packages');
        print('[DEBUG] Packages: $packages');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load packages';
        print('[DEBUG] fetchPackages: Error - ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Error loading packages: $e';
      print('Error fetching packages: $e');
    } finally {
      isLoading.value = false;
      print('[DEBUG] fetchPackages: Completed, isLoading = ${isLoading.value}');
    }
  }

  void selectPackage(String title) {
    print('[DEBUG] selectPackage: Selected package - $title');
    selectedPackage.value = title;
    // Find and set the package ID
    final package = packages.firstWhereOrNull((pkg) => pkg.title == title);
    if (package != null) {
      selectedPackageId.value = package.id;
      print('[DEBUG] selectPackage: Package ID set to ${package.id}');
    } else {
      print('[DEBUG] selectPackage: Package not found!');
    }
  }

  Future<void> submitBoatOnboarding() async {
    try {
      print(
        '[DEBUG] submitBoatOnboarding: Starting boat onboarding submission',
      );
      isLoading.value = true;
      errorMessage.value = '';

      // Check if user is logged in
      final isLoggedIn = StorageService.hasToken();
      print('[DEBUG] User is logged in: $isLoggedIn');

      // Validate required fields
      print('[DEBUG] submitBoatOnboarding: Validating required fields');
      if (nameController.text.isEmpty) {
        throw Exception('Boat name is required');
      }
      print('[DEBUG] Boat name: ${nameController.text}');
      if (selectedPackageId.value.isEmpty) {
        throw Exception('Please select a package first');
      }
      print('[DEBUG] Selected Package ID: ${selectedPackageId.value}');

      // Only validate seller fields if user is NOT logged in
      if (!isLoggedIn) {
        if (sellerEmailController.text.isEmpty) {
          throw Exception('Seller email is required');
        }
        print('[DEBUG] Seller email: ${sellerEmailController.text}');
      }
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
        'enginesNumber': int.tryParse(selectedNumberOfEngine.value ?? '1') ?? 1,
        'cabinsNumber': int.tryParse(selectedNumberOfCabin.value ?? '1') ?? 1,
        'headsNumber': int.tryParse(selectedNumberOfHeads.value ?? '1') ?? 1,
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
        'coversEquipment':
            <String>[], // This stays as is based on your original code
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

      // Try simple JSON approach first (without file uploads)
      print('[DEBUG] Attempting submission without file uploads first...');
      try {
        final response = await ApiService.createBoatOnboardingSimple(
          boatInfo: boatInfo,
          sellerInfo: sellerInfo,
          planId: selectedPackageId.value,
        );

        print('[DEBUG] submitBoatOnboarding: Response received - $response');

        if (response['success'] == true) {
          // Store payment intent data
          final data = response['data'];
          if (data != null) {
            paymentIntentId.value = data['paymentIntentId'] ?? '';
            paymentIntentClientSecret.value =
                data['paymentIntentClientSecret'] ?? '';
            userId.value = data['userId'] ?? '';

            if (data['listingPreview'] != null) {
              listingId.value = data['listingPreview']['listingId'] ?? '';
            }

            print('\n=== Onboarding Success ===');
            print('Listing ID: ${listingId.value}');
            print('Payment Intent ID: ${paymentIntentId.value}');
            print('User ID: ${userId.value}');
            print('========================\n');
          }

          Get.snackbar(
            'Success',
            'Boat listing created successfully! Listing ID: ${listingId.value}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );

          // Only perform login if user is not already logged in
          if (!isLoggedIn) {
            await performHiddenLogin(
              email: sellerEmailController.text.trim(),
              password: sellerPasswordController.text,
            );
          } else {
            // User is already logged in, just fetch setup intent
            print('[DEBUG] User already logged in, fetching setup intent...');
            userId.value = StorageService.userId ?? '';
            await _fetchSetupIntentForPayment();
          }

          // TODO: Navigate to payment screen with payment intent
          // Get.toNamed('/payment', arguments: {
          //   'clientSecret': paymentIntentClientSecret.value,
          //   'listingId': listingId.value,
          // });

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
      final response = await ApiService.createBoatOnboarding(
        boatInfo: boatInfo,
        sellerInfo: sellerInfo,
        planId: selectedPackageId.value,
        coverPaths: coverPaths,
        galleryPaths: galleryPaths,
      );

      print('[DEBUG] submitBoatOnboarding: File upload response - $response');

      if (response['success'] == true) {
        // Store payment intent data
        final data = response['data'];
        if (data != null) {
          paymentIntentId.value = data['paymentIntentId'] ?? '';
          paymentIntentClientSecret.value =
              data['paymentIntentClientSecret'] ?? '';
          userId.value = data['userId'] ?? '';

          if (data['listingPreview'] != null) {
            listingId.value = data['listingPreview']['listingId'] ?? '';
          }
        }

        Get.snackbar(
          'Success',
          'Boat listing created successfully with images! Listing ID: ${listingId.value}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );

        // Only perform login if user is not already logged in
        if (!isLoggedIn) {
          await performHiddenLogin(
            email: sellerEmailController.text.trim(),
            password: sellerPasswordController.text,
          );
        } else {
          // User is already logged in, just fetch setup intent
          print('[DEBUG] User already logged in, fetching setup intent...');
          userId.value = StorageService.userId ?? '';
          await _fetchSetupIntentForPayment();
        }

        // Navigate to payment or success screen
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

  /// Perform hidden login with seller credentials and fetch setup intent for payment
  Future<void> performHiddenLogin({
    required String email,
    required String password,
  }) async {
    try {
      print('═══════════════════════════════════════════════════════');
      print('🔐 HIDDEN LOGIN INITIATED');
      print('═══════════════════════════════════════════════════════');

      // Ensure StorageService is initialized
      if (!StorageService.isInitialized) {
        await StorageService.init();
      }

      // Call login API
      final response = await ApiService.login(email: email, password: password);

      print('\n📋 LOGIN RESPONSE:');
      print('Response: $response\n');

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data']['user'];
        final String userId = userData['id'];
        final String token = response['data']['token'];

        // Save token to storage
        await StorageService.saveToken(token, userId);

        // Store token in observable
        accessToken.value = token;
        this.userId.value = userId;

        print('═══════════════════════════════════════════════════════');
        print('✅ HIDDEN LOGIN SUCCESSFUL');
        print('═══════════════════════════════════════════════════════');
        print('📧 Email: $email');
        print('👤 User ID: $userId');
        print('🔑 Access Token: $token');
        print('═══════════════════════════════════════════════════════\n');

        // Now fetch the setup intent for payment
        print('\n🔄 Fetching Setup Intent for Payment...\n');
        await _fetchSetupIntentForPayment();
      } else {
        print('❌ Login failed: ${response['message']}\n');
      }
    } catch (e) {
      print('❌ Hidden login error: $e\n');
      rethrow;
    }
  }

  /// Fetch setup intent data from backend for Stripe payment
  Future<void> _fetchSetupIntentForPayment() async {
    try {
      final response = await ApiService.getSetupIntent(selectedPackageId.value);

      print('\n💳 SETUP INTENT RESPONSE:');
      print('Response: $response\n');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        // Extract and store setup intent data
        setupIntentId.value = data['setupIntentId'] ?? '';
        setupIntentClientSecret.value = data['setupIntentSecret'] ?? '';
        planPrice.value = (data['amount'] ?? 0).toDouble();
        planTitle.value = data['planTitle'] ?? '';

        print('═══════════════════════════════════════════════════════');
        print('✅ SETUP INTENT FETCHED SUCCESSFULLY');
        print('═══════════════════════════════════════════════════════');
        print('💳 Setup Intent ID: ${setupIntentId.value}');
        print('🔐 Client Secret: ${setupIntentClientSecret.value}');
        print('💰 Plan Price: \$${planPrice.value.toStringAsFixed(2)}');
        print('📋 Plan Title: ${planTitle.value}');
        print('═══════════════════════════════════════════════════════\n');
      } else {
        print('❌ Failed to fetch setup intent: ${response['message']}\n');
        throw Exception('Failed to fetch setup intent: ${response['message']}');
      }
    } catch (e) {
      print('❌ Error fetching setup intent: $e\n');
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

      // Check if card details are present from CardField
      final cardDetails = cardFieldInputDetails.value;
      print('[DEBUG] Card Details State:');
      print('[DEBUG]   - cardDetails is null: ${cardDetails == null}');
      if (cardDetails != null) {
        print('[DEBUG]   - cardDetails.complete: ${cardDetails.complete}');
        print('[DEBUG]   - cardDetails.brand: ${cardDetails.brand}');
      }

      if (cardDetails == null) {
        throw Exception(
          'Card details are required. Please enter valid card information.',
        );
      }

      // Validate card is complete
      if (!cardDetails.complete) {
        throw Exception(
          'Card details are incomplete. Please fill in all required fields.',
        );
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Fetch a fresh setup intent for this payment attempt
      print('[DEBUG] Fetching fresh setup intent for payment...');
      await _fetchSetupIntentForPayment();

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
        cardFieldInputDetails.value = null;

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
