import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:diaz1234567890/features/ai/controller/ai_chat_controller.dart';
import 'package:diaz1234567890/features/auth/login_screen/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AiChatController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AiChatController());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    _controller.sendMessage(text);
    _inputController.clear();

    // scroll to bottom after frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Image.asset(Iconpath.askAi, width: 18, height: 18),
            const SizedBox(width: 8),
            const Text(
              'Florida Yacht AI',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // If user not logged in, show login prompt
          if (!_controller.isUserLoggedIn.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Login Required',
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Please login to access the AI Chat feature and get personalized yacht recommendations.',
                      textAlign: TextAlign.center,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.offAll(() => LoginScreen());
                      },
                      icon: const Icon(Icons.login),
                      label: const Text('Go to Login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Loading state
          if (_controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading chat history...',
                    style: getTextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Chat messages
          return Column(
            children: [
              Expanded(
                child: _controller.messages.isEmpty
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Image.asset(Iconpath.askAi, width: 48, height: 48),
                            const SizedBox(height: 20),
                            Text(
                              'Welcome to Florida Yacht Trader AI',
                              style: getTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ).copyWith(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ask me anything about yachts, boats, or marine listings...',
                              style: getTextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ).copyWith(fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        itemCount: _controller.messages.length,
                        itemBuilder: (context, index) {
                          final msg = _controller.messages[index];
                          final isUser = msg['isUser'] as bool;
                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Colors.blue.shade50
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                msg['text'] as String,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Error message
              if (_controller.errorMessage.value != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _controller.errorMessage.value!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              // Bottom input bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _inputController,
                                enabled: !_controller.isSendingMessage.value,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  hintText:
                                      'Ask about yachts, prices, features...',
                                  border: InputBorder.none,
                                  enabled: !_controller.isSendingMessage.value,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                Iconpath.askAi,
                                width: 18,
                                height: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: _controller.isSendingMessage.value
                                  ? null
                                  : _sendMessage,
                              icon: _controller.isSendingMessage.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.send, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
