
import 'package:diaz1234567890/features/about_us/model/contact_info_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkingHourCard extends StatelessWidget {
  final RxList<WorkingHour> workingHours;
  final RxString backgroundImageUrl;

  const WorkingHourCard({
    super.key,
    required this.workingHours,
    required this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final defaultItems = ['', '', '', '', '', ''];

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 210,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [const Color(0xFF00CABE), const Color(0xFF006EF0)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 0),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.23,
                  children: [
                    const Text(
                      'Working Hours',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.34,
                      ),
                    ),
                    Obx(() {
                      final items = workingHours.isEmpty
                          ? defaultItems
                          : workingHours
                                .map((h) => '${h.day}: ${h.hours}')
                                .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: items
                            .map(
                              (s) => Padding(
                                padding: const EdgeInsets.only(bottom: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(top: 6),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxWidth: 190,
                                      ),
                                      child: Text(
                                        s,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 50,
          child: Obx(
            () => SizedBox(
              width: 150,
              height: 126,
              child: backgroundImageUrl.value.isNotEmpty
                  ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                      child: Image.network(
                        backgroundImageUrl.value,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Image.asset(
                          '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                      child: Image.asset(
                        '',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
