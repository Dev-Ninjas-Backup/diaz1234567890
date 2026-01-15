import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:diaz1234567890/core/services/firebase/storage_service.dart';
import 'package:diaz1234567890/features/ai/service/ai_chat_service.dart';

class AiChatController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSendingMessage = false.obs;
  final errorMessage = RxnString();

  // Use Rx observable for reactive updates
  var userId = ''.obs;
  var isUserLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    // Ensure StorageService is initialized
    if (!StorageService.isInitialized) {
      await StorageService.init();
    }

    // Get user info from storage
    final storedUserId = StorageService.userId ?? '';
    final hasToken = StorageService.hasToken();

    userId.value = storedUserId;
    isUserLoggedIn.value = storedUserId.isNotEmpty && hasToken;

    if (kDebugMode) {
      print('AiChatController: User ID = ${userId.value}');
      print('AiChatController: Is Logged In = ${isUserLoggedIn.value}');
    }

    // Load chat history only if logged in
    if (isUserLoggedIn.value) {
      await _loadChatHistory();
    }
  }

  Future<void> _loadChatHistory() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final history = await AiChatService.getChatHistory(userId: userId.value);

      // Convert to our message format
      messages.clear();
      for (final msg in history) {
        messages.add({
          'text': msg['content'] ?? '',
          'isUser': msg['role'] == 'user',
          'role': msg['role'] ?? 'assistant',
        });
      }

      if (kDebugMode) {
        print(
          'AiChatController: Loaded ${messages.length} messages from history',
        );
      }
    } catch (e) {
      errorMessage.value = 'Failed to load chat history: $e';
      if (kDebugMode) print('AiChatController: Error loading history - $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    if (!isUserLoggedIn.value) {
      errorMessage.value = 'Please login to use AI Chat';
      return;
    }

    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return;

    // Add user message to UI immediately
    messages.add({'text': trimmedText, 'isUser': true, 'role': 'user'});

    isSendingMessage.value = true;
    errorMessage.value = null;

    try {
      final response = await AiChatService.sendMessage(
        message: trimmedText,
        userId: userId.value,
      );

      // Handle different response formats
      String aiReply = '';
      // Try different possible response fields (messages is primary for Florida AI)
      aiReply =
          response['messages'] ??
          response['content'] ??
          response['message'] ??
          response['reply'] ??
          response['data'] ??
          '';

      if (aiReply.isNotEmpty) {
        messages.add({'text': aiReply, 'isUser': false, 'role': 'assistant'});
      } else {
        throw Exception('No response from AI');
      }

      if (kDebugMode) {
        print('AiChatController: AI replied with: $aiReply');
      }
    } catch (e) {
      final err = e.toString();
      final isNotFound = err.contains('404') ||
          err.contains('Not Found') ||
          err.contains('Cannot POST');

      // Keep the user's message in the chat (don't remove it). Show a friendly
      // assistant message so the UI still feels responsive.
      final friendly = isNotFound
          ? 'AI chat is currently unavailable (endpoint not found). Please try again later.'
          : 'Sorry — something went wrong while contacting the AI service. Please try again.';

      errorMessage.value = friendly;
      messages.add({'text': friendly, 'isUser': false, 'role': 'assistant'});

      if (kDebugMode) print('AiChatController: Error sending message - $e');
    } finally {
      isSendingMessage.value = false;
    }
  }

  void clearChat() {
    messages.clear();
  }
}
