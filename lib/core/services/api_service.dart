// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';

class ApiService {
  static const String baseUrl =
      'https://api.floridayachttrader.com'; // Replace with your actual base URL

  /// Get MIME type from file extension
  static MediaType _getMediaType(String filename) {
    final ext = filename.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'webp':
        return MediaType('image', 'webp');
      case 'heic':
        return MediaType('image', 'heic');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  static Future<dynamic> getSetupIntent(String planId) async {
    try {
      print('\n=== Fetching Setup Intent ===');
      print('URL: ${Endpoints.setupIntent(planId)}');

      // Ensure StorageService is initialized
      if (!StorageService.isInitialized) {
        await StorageService.init();
      }

      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        throw Exception('No access token available. Please login first.');
      }

      print('Authorization: Bearer $token');

      final response = await http
          .post(
            Uri.parse(
              Endpoints.setupIntent(planId),
            ), // Replace with actual plan ID
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('=============================\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Failed to get setup intent (${response.statusCode})',
          );
        } catch (e) {
          throw Exception(
            'Failed to get setup intent (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      print('Error fetching setup intent: $e');
      throw Exception('Error fetching setup intent: $e');
    }
  }

  /// Tokenize card details on the backend to get a PaymentMethod ID
  static Future<dynamic> getSubscriptionConfirmation({
    required String userId,
  }) async {
    try {
      if (userId.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      print('\n=== Fetching Subscription Confirmation ===');
      print('URL: $baseUrl/api/boats/seller/subscription-confirmation/$userId');
      print('========================================\n');

      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/api/boats/seller/subscription-confirmation/$userId',
            ),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Parsed JSON: $jsonData');
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Failed to get confirmation (${response.statusCode})',
          );
        } catch (e) {
          throw Exception(
            'Failed to get confirmation (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      print('Error fetching subscription confirmation: $e');
      throw Exception('Error fetching subscription confirmation: $e');
    }
  }

  static Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    try {
      final requestBody = {'email': email, 'password': password};

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/auth/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Login failed (${response.statusCode}): ${response.body}',
          );
        } catch (e) {
          throw Exception(
            'Login failed (${response.statusCode}): ${response.body}',
          );
        }
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  static Future<dynamic> getSubscriptionPlans() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/subscription/plans'))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching plans: $e');
    }
  }

  static Future<dynamic> getBoatClasses() async {
    try {
      final response = await http
          .get(Uri.parse(Endpoints.getclass))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception('Failed to load boat classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching boat classes: $e');
    }
  }

  static Future<dynamic> createBoatOnboardingSimple({
    required Map<String, dynamic> boatInfo,
    required Map<String, dynamic> sellerInfo,
    required String planId,
  }) async {
    try {
      final requestBody = {
        'boatInfo': boatInfo,
        'sellerInfo': sellerInfo,
        'planId': planId,
      };

      print('\n=== Simple JSON Request (No Files) ===');
      print('URL: ${Endpoints.onboarding}');
      print('\\nBoat Info Keys: ${boatInfo.keys.toList()}');
      print('\\nBoat Info:');
      boatInfo.forEach((key, value) {
        print('  $key: $value (${value.runtimeType})');
      });
      print('\\nRequest Body: ${json.encode(requestBody)}');
      print('=====================================\n');

      final response = await http
          .post(
            Uri.parse(Endpoints.onboarding),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Server error (${response.statusCode}): ${response.body}',
          );
        } catch (e) {
          throw Exception(
            'Server error (${response.statusCode}): ${response.body}',
          );
        }
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: ${e.message}. Check your internet connection.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Connection error: ${e.message}. The server may be unavailable.',
      );
    } catch (e) {
      throw Exception('Error creating boat listing: $e');
    }
  }

  static Future<dynamic> createBoatOnboarding({
    required Map<String, dynamic> boatInfo,
    required Map<String, dynamic> sellerInfo,
    required String planId,
    List<String>? coverPaths,
    List<String>? galleryPaths,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.onboarding),
      );

      // Remove covers and galleries from boatInfo before sending
      final boatInfoCopy = Map<String, dynamic>.from(boatInfo);
      boatInfoCopy.remove('covers');
      boatInfoCopy.remove('galleries');

      // Add text fields
      request.fields['boatInfo'] = json.encode(boatInfoCopy);
      request.fields['sellerInfo'] = json.encode(sellerInfo);
      request.fields['planId'] = planId;

      print('\n=== API Multipart Request ===');
      print('URL: ${Endpoints.onboarding}');
      print('boatInfo: ${json.encode(boatInfoCopy)}');
      print('sellerInfo: ${json.encode(sellerInfo)}');
      print('planId: $planId');

      // Add cover image
      if (coverPaths != null && coverPaths.isNotEmpty) {
        for (var path in coverPaths) {
          if (path.isNotEmpty) {
            var file = File(path);
            if (await file.exists()) {
              var fileSize = await file.length();
              var filename = path.split('/').last;
              var mediaType = _getMediaType(filename);
              print(
                'Cover file size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
              );
              print('Cover content type: ${mediaType.mimeType}');

              var stream = http.ByteStream(file.openRead());
              var multipartFile = http.MultipartFile(
                'covers',
                stream,
                fileSize,
                filename: filename,
                contentType: mediaType,
              );
              request.files.add(multipartFile);
              print('Added cover: $filename');
            }
          }
        }
      }

      // Add gallery images
      if (galleryPaths != null && galleryPaths.isNotEmpty) {
        for (var path in galleryPaths) {
          if (path.isNotEmpty) {
            var file = File(path);
            if (await file.exists()) {
              var fileSize = await file.length();
              var filename = path.split('/').last;
              var mediaType = _getMediaType(filename);
              print(
                'Gallery file size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
              );
              print('Gallery content type: ${mediaType.mimeType}');

              var stream = http.ByteStream(file.openRead());
              var multipartFile = http.MultipartFile(
                'galleries',
                stream,
                fileSize,
                filename: filename,
                contentType: mediaType,
              );
              request.files.add(multipartFile);
              print('Added gallery: $filename');
            }
          }
        }
      }

      print('Total files: ${request.files.length}');
      print('Sending request...');
      print('=============================\n');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 120),
        onTimeout: () =>
            throw Exception('Upload timeout - files may be too large'),
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('\n=== API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('===================\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Server error (${response.statusCode}): ${response.body}',
          );
        } catch (e) {
          throw Exception(
            'Server error (${response.statusCode}): ${response.body}',
          );
        }
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: ${e.message}. Check your internet connection.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Connection error: ${e.message}. The server may be unavailable or files are too large.',
      );
    } catch (e) {
      throw Exception('Error creating boat listing: $e');
    }
  }

  /// Create listing for authenticated users (without file uploads)
  static Future<dynamic> createListing({
    required Map<String, dynamic> boatInfo,
    required String planId,
  }) async {
    try {
      // Ensure StorageService is initialized and we have a token
      if (!StorageService.isInitialized) {
        await StorageService.init();
      }

      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        throw Exception('No access token available. User must be logged in.');
      }

      final requestBody = {'boatInfo': boatInfo, 'planId': planId};

      print('\n=== Create Listing Request (Authenticated User) ===');
      print('URL: ${Endpoints.createListing}');
      print('Authorization: Bearer $token');
      print('Body: ${json.encode(requestBody)}');
      print('====================================================\n');

      final response = await http
          .post(
            Uri.parse(Endpoints.createListing),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Server error (${response.statusCode}): ${response.body}',
          );
        } catch (e) {
          throw Exception(
            'Server error (${response.statusCode}): ${response.body}',
          );
        }
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: ${e.message}. Check your internet connection.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Connection error: ${e.message}. The server may be unavailable.',
      );
    } catch (e) {
      throw Exception('Error creating boat listing: $e');
    }
  }

  /// Create listing for authenticated users (with file uploads)
  static Future<dynamic> createListingWithFiles({
    required Map<String, dynamic> boatInfo,
    required String planId,
    List<String>? coverPaths,
    List<String>? galleryPaths,
  }) async {
    try {
      // Ensure StorageService is initialized and we have a token
      if (!StorageService.isInitialized) {
        await StorageService.init();
      }

      final token = StorageService.token;
      if (token == null || token.isEmpty) {
        throw Exception('No access token available. User must be logged in.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.createListing),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';

      // Remove covers and galleries from boatInfo before sending
      final boatInfoCopy = Map<String, dynamic>.from(boatInfo);
      boatInfoCopy.remove('covers');
      boatInfoCopy.remove('galleries');

      // Add text fields
      request.fields['boatInfo'] = json.encode(boatInfoCopy);
      request.fields['planId'] = planId;

      print('\n=== Create Listing with Files Request (Authenticated User) ===');
      print('URL: ${Endpoints.createListing}');
      print('Authorization: Bearer $token');
      print('boatInfo: ${json.encode(boatInfoCopy)}');
      print('planId: $planId');

      // Add cover image
      if (coverPaths != null && coverPaths.isNotEmpty) {
        for (var path in coverPaths) {
          if (path.isNotEmpty) {
            var file = File(path);
            if (await file.exists()) {
              var fileSize = await file.length();
              var filename = path.split('/').last;
              var mediaType = _getMediaType(filename);

              var stream = http.ByteStream(file.openRead());
              var multipartFile = http.MultipartFile(
                'covers',
                stream,
                fileSize,
                filename: filename,
                contentType: mediaType,
              );
              request.files.add(multipartFile);
              print('Added cover: $filename');
            }
          }
        }
      }

      // Add gallery images
      if (galleryPaths != null && galleryPaths.isNotEmpty) {
        for (var path in galleryPaths) {
          if (path.isNotEmpty) {
            var file = File(path);
            if (await file.exists()) {
              var fileSize = await file.length();
              var filename = path.split('/').last;
              var mediaType = _getMediaType(filename);

              var stream = http.ByteStream(file.openRead());
              var multipartFile = http.MultipartFile(
                'galleries',
                stream,
                fileSize,
                filename: filename,
                contentType: mediaType,
              );
              request.files.add(multipartFile);
              print('Added gallery: $filename');
            }
          }
        }
      }

      print('Total files: ${request.files.length}');
      print('Sending request...');
      print(
        '================================================================\n',
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 120),
        onTimeout: () =>
            throw Exception('Upload timeout - files may be too large'),
      );

      final response = await http.Response.fromStream(streamedResponse);

      print('\n=== API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('===================\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Server error (${response.statusCode}): ${response.body}',
          );
        } catch (e) {
          throw Exception(
            'Server error (${response.statusCode}): ${response.body}',
          );
        }
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: ${e.message}. Check your internet connection.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Connection error: ${e.message}. The server may be unavailable or files are too large.',
      );
    } catch (e) {
      throw Exception('Error creating boat listing: $e');
    }
  }

  /// Test endpoint with minimal payload to debug 500 errors
  static Future<dynamic> createBoatOnboardingMinimal({
    required String boatName,
    required double price,
    required String make,
    required String model,
    required int buildYear,
    required String city,
    required String state,
    required String zip,
    required String sellerName,
    required String sellerEmail,
    required String username,
    required String password,
    required String planId,
  }) async {
    try {
      final requestBody = {
        'boatInfo': {
          'name': boatName,
          'price': price,
          'make': make,
          'model': model,
          'buildYear': buildYear,
          'city': city,
          'state': state,
          'zip': zip,
        },
        'sellerInfo': {
          'name': sellerName,
          'email': sellerEmail,
          'username': username,
          'password': password,
        },
        'planId': planId,
      };

      print('\n=== Minimal Test Request ===');
      print('URL: ${Endpoints.onboarding}');
      print('Body: ${json.encode(requestBody)}');
      print('=============================\n');

      final response = await http
          .post(
            Uri.parse(Endpoints.onboarding),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      print('\n=== API Response ===');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('===================\n');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        throw Exception(
          'Server error (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error with minimal test: $e');
    }
  }
}
