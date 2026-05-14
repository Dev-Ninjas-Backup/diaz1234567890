// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:diaz1234567890/features/about_us/model/contact_info_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';


class TeamMemberData {
  final String imageUrl;
  final String name;
  final String role;
  final String description;
  final double avatarSize;

  TeamMemberData({
    required this.imageUrl,
    required this.name,
    required this.role,
    required this.description,
    this.avatarSize = 40.62,
  });
}

class AboutUsController extends GetxController {
  final aboutTitle = 'About Us'.obs;
  final aboutDescription = ''.obs;
  final mission = ''.obs;
  final vision = ''.obs;
  final members = <TeamMemberData>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Contact Info
  final contactInfo = Rx<ContactInfoData?>(null);
  final address = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final workingHours = <WorkingHour>[].obs;
  final socialMedia = <String, String>{}.obs;
  final contactBackgroundImage = ''.obs;

  // Why Us Section
  final whyUsTitle = ''.obs;
  final whyUsDescription = ''.obs;
  final excellenceYears = ''.obs;
  final boatsSoldPerYear = ''.obs;
  final listingsViewed = ''.obs;
  final image1Url = ''.obs;
  final image2Url = ''.obs;
  final image3Url = ''.obs;
  final buttonText = ''.obs;
  final buttonLink = ''.obs;

  // Our Story Section
  final ourStoryTitle = ''.obs;
  final ourStoryDescription = ''.obs;
  final storyImage4Url = ''.obs;
  final storyImage5Url = ''.obs;
  final storyImage3Url = ''.obs;

  // What Sets Us Apart Section
  final whatSetsUsApartDescription = ''.obs;
  final whatSetsUsApartImage1Url = ''.obs;
  final whatSetsUsApartImage2Url = ''.obs;
  final whatSetsUsApartYears = ''.obs;
  final whatSetsUsApartBoats = ''.obs;
  final whatSetsUsApartListings = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAboutUsData();
    //fetchTeamMembers();
    fetchContactInfo();
    fetchWhyUsData();
    fetchOurStoryData();
    fetchWhatSetsUsApartData();
  }

  Future<void> fetchAboutUsData() async {
    try {
      final dio = Dio();
      final response = await dio.get(Endpoints.aboutUs);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final aboutData = data['data'] as Map<String, dynamic>;

        aboutTitle.value = aboutData['aboutTitle'] as String? ?? 'About Us';
        final htmlDescription = aboutData['aboutDescription'] as String? ?? '';
        aboutDescription.value = _decodeHtmlContent(htmlDescription);

        final htmlMission = aboutData['mission'] as String? ?? '';
        mission.value = _decodeHtmlContent(htmlMission);

        final htmlVision = aboutData['vision'] as String? ?? '';
        vision.value = _decodeHtmlContent(htmlVision);

        print('✅ About Us data loaded');
      }
    } catch (e) {
      print('❌ Error fetching About Us: $e');
      errorMessage.value = 'Failed to load About Us data';
    }
  }

  // Future<void> fetchTeamMembers() async {
  //   try {
  //     isLoading.value = true;
  //     final dio = Dio();
  //     final response = await dio.get(Endpoints.teamMembers);

  //     if (response.statusCode == 200) {
  //       final data = response.data as Map<String, dynamic>;
  //       final teamData = data['data'] as List<dynamic>? ?? [];

  //       final parsedMembers = teamData
  //           .map(
  //             (member) => TeamMemberData(
  //               imageUrl:
  //                   (member['image'] as Map<String, dynamic>? ?? {})['url']
  //                       as String? ??
  //                   '',
  //               name: member['name'] as String? ?? '',
  //               role: member['designation'] as String? ?? '',
  //               description: member['bio'] as String? ?? '',
  //               avatarSize: 40.62,
  //             ),
  //           )
  //           .where((m) => m.imageUrl.isNotEmpty && m.name.isNotEmpty)
  //           .toList();

  //       members.assignAll(parsedMembers);
  //       print('✅ Team members loaded: ${parsedMembers.length}');
  //     }
  //   } catch (e) {
  //     print('❌ Error fetching team members: $e');
  //     errorMessage.value = 'Failed to load team members';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchContactInfo() async {
    try {
      final dio = Dio();
      final response = await dio.get(Endpoints.contactInfo);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final contactData = data['data'] as Map<String, dynamic>;

        address.value = (contactData['address'] as String?) ?? '';
        email.value = (contactData['email'] as String?) ?? '';
        phone.value = (contactData['phone'] as String?) ?? '';

        // Parse working hours
        final hoursData = contactData['workingHours'] as List<dynamic>? ?? [];
        final parsedHours = hoursData
            .map(
              (hour) => WorkingHour(
                day: (hour['day'] as String?) ?? '',
                hours: (hour['hours'] as String?) ?? '',
              ),
            )
            .toList();
        workingHours.assignAll(parsedHours);

        // Parse social media
        final socialData =
            contactData['socialMedia'] as Map<String, dynamic>? ?? {};
        final parsedSocial = <String, String>{};
        socialData.forEach((key, value) {
          parsedSocial[key] = (value as String?) ?? '';
        });
        socialMedia.assignAll(parsedSocial);

        // Background image URL if provided
        final bg = contactData['backgroundImage'] as Map<String, dynamic>?;
        contactBackgroundImage.value = (bg != null && bg['url'] != null)
            ? bg['url'] as String
            : '';
        print('✅ Contact info loaded');

        print('✅ Contact info loaded');
      }
    } catch (e) {
      print('❌ Error fetching contact info: $e');
      errorMessage.value = 'Failed to load contact info';
    }
  }

  Future<void> fetchWhyUsData() async {
    try {
      final dio = Dio();
      final response = await dio.get(Endpoints.whyUs);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final whyUsData = data['data'] as Map<String, dynamic>;

        whyUsTitle.value = (whyUsData['title'] as String?) ?? '';
        whyUsDescription.value = (whyUsData['description'] as String?) ?? '';
        excellenceYears.value = (whyUsData['excellence'] as String?) ?? '';
        boatsSoldPerYear.value =
            (whyUsData['boatsSoldPerYear'] as String?) ?? '';
        listingsViewed.value = (whyUsData['listingViewed'] as String?) ?? '';
        buttonText.value = (whyUsData['buttonText'] as String?) ?? '';
        buttonLink.value = (whyUsData['buttonLink'] as String?) ?? '';

        // Parse image URLs
        final image1 = whyUsData['image1'] as Map<String, dynamic>? ?? {};
        image1Url.value = (image1['url'] as String?) ?? '';

        final image2 = whyUsData['image2'] as Map<String, dynamic>? ?? {};
        image2Url.value = (image2['url'] as String?) ?? '';

        final image3 = whyUsData['image3'] as Map<String, dynamic>? ?? {};
        image3Url.value = (image3['url'] as String?) ?? '';

        print('✅ Why Us data loaded');
      }
    } catch (e) {
      print('❌ Error fetching Why Us data: $e');
      errorMessage.value = 'Failed to load Why Us data';
    }
  }

  Future<void> fetchOurStoryData() async {
    try {
      final dio = Dio();
      final response = await dio.get(Endpoints.ourStory);

      if (response.statusCode == 200) {
        try {
          final responseData = response.data;
          print('Debug: Response data type: ${responseData.runtimeType}');

          if (responseData == null) {
            print('Debug: Response data is null');
            return;
          }

          // The API returns the data directly, not wrapped in a 'data' field
          final storyData = responseData is Map
              ? responseData as Map<String, dynamic>
              : {};

          print('Debug: Story data keys: ${storyData.keys.toList()}');

          if (storyData.isEmpty) {
            print('Debug: Story data is empty');
            return;
          }

          ourStoryTitle.value = (storyData['title'] as String?) ?? '';
          ourStoryDescription.value =
              (storyData['description'] as String?) ?? '';

          print('Debug: Title: ${ourStoryTitle.value}');
          print('Debug: Description: ${ourStoryDescription.value}');

          // Parse image URLs safely
          if (storyData['image3'] is Map) {
            final image3 = storyData['image3'] as Map<String, dynamic>;
            storyImage3Url.value = (image3['url'] as String?) ?? '';
            print('Debug: Image3 URL: ${storyImage3Url.value}');
          }

          if (storyData['image4'] is Map) {
            final image4 = storyData['image4'] as Map<String, dynamic>;
            storyImage4Url.value = (image4['url'] as String?) ?? '';
            print('Debug: Image4 URL: ${storyImage4Url.value}');
          }

          if (storyData['image5'] is Map) {
            final image5 = storyData['image5'] as Map<String, dynamic>;
            storyImage5Url.value = (image5['url'] as String?) ?? '';
            print('Debug: Image5 URL: ${storyImage5Url.value}');
          }

          print('✅ Our Story data loaded');
        } catch (parseError) {
          print('❌ Error parsing Our Story data: $parseError');
          errorMessage.value = 'Failed to parse Our Story data: $parseError';
        }
      }
    } catch (e) {
      print('❌ Error fetching Our Story data: $e');
      errorMessage.value = 'Failed to load Our Story data';
    }
  }

  /// Decode HTML content and strip tags
  String _decodeHtmlContent(String htmlContent) {
    String decoded = _decodeHtmlEntities(htmlContent);
    decoded = _stripHtmlTags(decoded);
    return decoded.trim();
  }

  /// Decode HTML entities
  String _decodeHtmlEntities(String text) {
    String decoded = text;

    final entities = {
      '&nbsp;': ' ',
      '&quot;': '"',
      '&apos;': "'",
      '&#39;': "'",
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&mdash;': '—',
      '&ndash;': '–',
      '&hellip;': '…',
      '&rsquo;': ''',
      '&lsquo;': ''',
      '&rdquo;': '"',
      '&ldquo;': '"',
      '&bull;': '•',
      '&times;': '×',
      '&divide;': '÷',
      '&euro;': '€',
      '&pound;': '£',
      '&yen;': '¥',
      '&cent;': '¢',
      '&copy;': '©',
      '&reg;': '®',
      '&trade;': '™',
    };

    entities.forEach((entity, replacement) {
      decoded = decoded.replaceAll(entity, replacement);
    });

    // Handle numeric entities like &#123;
    decoded = decoded.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
      try {
        final codeUnit = int.parse(match.group(1) ?? '0');
        return String.fromCharCode(codeUnit);
      } catch (_) {
        return match.group(0) ?? '';
      }
    });

    // Handle hex entities like &#x1F;
    decoded = decoded.replaceAllMapped(RegExp(r'&#x([0-9A-Fa-f]+);'), (match) {
      try {
        final codeUnit = int.parse(match.group(1) ?? '0', radix: 16);
        return String.fromCharCode(codeUnit);
      } catch (_) {
        return match.group(0) ?? '';
      }
    });

    return decoded;
  }

  /// Strip HTML tags from text
  String _stripHtmlTags(String text) {
    final tagPattern = RegExp(r'<[^>]*>');
    return text.replaceAll(tagPattern, '');
  }

  Future<void> fetchWhatSetsUsApartData() async {
    try {
      final dio = Dio();
      final response = await dio.get(Endpoints.whatSetsUsApart);

      if (response.statusCode == 200) {
        try {
          final responseData = response.data;
          print(
            'Debug: What Sets Us Apart response type: ${responseData.runtimeType}',
          );

          if (responseData == null) {
            print('Debug: What Sets Us Apart response is null');
            return;
          }

          // The API returns the data directly, not wrapped in a 'data' field
          final setApartData = responseData is Map
              ? responseData as Map<String, dynamic>
              : {};

          print('Debug: Set Apart data keys: ${setApartData.keys.toList()}');

          if (setApartData.isEmpty) {
            print('Debug: Set Apart data is empty');
            return;
          }

          // Parse description
          final htmlDescription = setApartData['description'] as String? ?? '';
          whatSetsUsApartDescription.value = _decodeHtmlContent(
            htmlDescription,
          );

          // Parse stats
          whatSetsUsApartYears.value =
              (setApartData['yearsOfYachtingExcellence'] as String?) ?? '';
          whatSetsUsApartBoats.value =
              (setApartData['boatsSoldIn2024'] as String?) ?? '';
          whatSetsUsApartListings.value =
              (setApartData['listingsViewedMonthly'] as String?) ?? '';

          print('Debug: Description: ${whatSetsUsApartDescription.value}');
          print('Debug: Years: ${whatSetsUsApartYears.value}');
          print('Debug: Boats: ${whatSetsUsApartBoats.value}');
          print('Debug: Listings: ${whatSetsUsApartListings.value}');

          // Parse image1 URL
          if (setApartData['image1'] is Map) {
            final image1 = setApartData['image1'] as Map<String, dynamic>;
            whatSetsUsApartImage1Url.value = (image1['url'] as String?) ?? '';
            print('Debug: Image1 URL: ${whatSetsUsApartImage1Url.value}');
          }

          // Parse image2 URL
          if (setApartData['image2'] is Map) {
            final image2 = setApartData['image2'] as Map<String, dynamic>;
            whatSetsUsApartImage2Url.value = (image2['url'] as String?) ?? '';
            print('Debug: Image2 URL: ${whatSetsUsApartImage2Url.value}');
          }

          print('✅ What Sets Us Apart data loaded');
        } catch (parseError) {
          print('❌ Error parsing What Sets Us Apart data: $parseError');
          errorMessage.value =
              'Failed to parse What Sets Us Apart data: $parseError';
        }
      }
    } catch (e) {
      print('❌ Error fetching What Sets Us Apart data: $e');
      errorMessage.value = 'Failed to load What Sets Us Apart data';
    }
  }
}
