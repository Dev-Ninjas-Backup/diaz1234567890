// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/endpoints/endpoints.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});
}

class FaqController extends GetxController {
  final heading = 'YOUR QUESTIONS ANSWERED'.obs;
  final intro = 'Find clear answers to common questions'.obs;
  final items = <FaqItem>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaq();
  }

  Future<void> fetchFaq() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final dio = Dio();
      final response = await dio.get(Endpoints.faq);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final faqData = data['data'] as Map<String, dynamic>;

        // Update heading and intro
        heading.value =
            faqData['title'] as String? ?? 'YOUR QUESTIONS ANSWERED';
        intro.value =
            faqData['subtitle'] as String? ??
            'Find clear answers to common questions';

        // Parse questions
        final questions = faqData['questions'] as List<dynamic>? ?? [];
        final parsedItems = questions
            .map(
              (q) => FaqItem(
                question: (q['question'] as String?) ?? '',
                answer: _decodeHtmlContent(q['answer'] as String? ?? ''),
              ),
            )
            .where((item) => item.question.isNotEmpty && item.answer.isNotEmpty)
            .toList();

        items.assignAll(parsedItems);
        print('✅ FAQ loaded with ${parsedItems.length} items');
      }
    } catch (e) {
      print('❌ Error fetching FAQ: $e');
      errorMessage.value = 'Failed to load FAQ';
    } finally {
      isLoading.value = false;
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

    // Common HTML entities
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

  /// Set default items if fetch fails
}
