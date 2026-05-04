import 'package:diaz1234567890/core/common/style/global_text_style.dart';
import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSearchFilterBar extends StatelessWidget {
  const HomeSearchFilterBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onFilterTap,
    required this.onSubmitted,
    required this.onAskAiTap,
  });

  final TextEditingController controller;
  final RxBool isLoading;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onAskAiTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onFilterTap,
            child: Image.asset(Iconpath.customTune, width: 25, height: 25),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Find me a Viking for sale from 2005 to 2008",
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ),
          ),
          Obx(
            () => TextButton(
              onPressed: isLoading.value ? null : onAskAiTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              child: isLoading.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      children: [
                        Image.asset(Iconpath.askAi, width: 18, height: 18),
                        const SizedBox(width: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "Ask AI",
                            style: getTextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
