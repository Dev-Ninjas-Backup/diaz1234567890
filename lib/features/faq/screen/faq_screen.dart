import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/faq_controller.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FaqController controller = Get.put(FaqController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 128,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.54, 1.00),
                  end: Alignment(0.54, -0.00),
                  colors: [const Color(0xFF00CABE), const Color(0xFF006EF0)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 6,
                    children: [
                      SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Text(
                        'FAQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(height: 16),
                      Text('Loading FAQ...'),
                    ],
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                  right: 25.0,
                  top: 30,
                  bottom: 50,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        controller.heading.value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.12,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        controller.intro.value,
                        style: TextStyle(
                          color: const Color(0xFF4A4D4D) /* grey-500 */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.items.map((f) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.question,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.19,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                f.answer,
                                style: const TextStyle(
                                  color: Color(0xFF4A4D4D),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: 0.49,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
