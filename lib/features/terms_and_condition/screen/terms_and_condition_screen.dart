import 'package:diaz1234567890/features/terms_and_condition/controller/terms_and_condition_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TermsAndConditionController controller = Get.put(
      TermsAndConditionController(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 128,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.54, 1.00),
                  end: Alignment(0.54, -0.00),
                  colors: [Color(0xFF00CABE), Color(0xFF006EF0)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Obx(
                        () => Text(
                          controller.title.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 50),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.errorMessage.value != null) {
                  return Center(
                    child: Text(
                      'Error: ${controller.errorMessage.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return HtmlWidget(
                  controller.description.value,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  customStylesBuilder: (element) {
                    if (element.localName == 'strong' ||
                        element.localName == 'h3') {
                      return {'color': 'black', 'font-weight': 'bold'};
                    }
                    if (element.localName == 'li') {
                      return {'margin-bottom': '8px'};
                    }
                    return null;
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
