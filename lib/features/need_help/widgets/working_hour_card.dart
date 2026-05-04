import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkingHourCard extends StatelessWidget {
  final RxList<dynamic> workingHours;
  final RxString backgroundImageUrl;

  const WorkingHourCard({
    super.key,
    required this.workingHours,
    required this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final defaultItems = [
      'Monday: 9am to 5pm',
      'Tuesday: 9am to 5pm',
      'Wednesday: 9am to 5pm',
      'Thursday: 9am to 5pm',
      'Friday: 9am to 5pm',
      'Weekend: Closed',
    ];

    return Obx(
      () => Container(
        width: double.infinity,
        height: 210,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF00CABE), Color(0xFF006EF0)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi), // Horizontal Flip
                child: backgroundImageUrl.value.isNotEmpty
                    ? Image.network(backgroundImageUrl.value, fit: BoxFit.cover)
                    : const SizedBox.shrink(),
              ),
            ),

            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.3), // Adjust darkness here
              ),
            ),

            // 3. THE CONTENTS
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Working Hours',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._buildHoursList(defaultItems),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildHoursList(List<String> defaults) {
    final List<dynamic> rawList = workingHours.isEmpty
        ? defaults
        : workingHours;

    return rawList.map((item) {
      String displayString = item is String
          ? item
          : "${item['day']}: ${item['hours']}";

      return Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              displayString,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}