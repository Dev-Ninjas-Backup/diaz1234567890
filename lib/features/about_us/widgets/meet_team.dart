// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/about_us_controller.dart';
import 'member_details_popup.dart';

class _TeamMember extends StatelessWidget {
  final TeamMemberData member;
  final double avatarSize;

  const _TeamMember({required this.member, this.avatarSize = 40.62});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.dialog(Center(child: MemberDetailsPopup(member: member)));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 2.71,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(member.imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Error loading team member image: $exception');
                },
              ),
              shape: OvalBorder(),
            ),
          ),
          Text(
            member.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.10,
            ),
          ),
          Text(
            member.role,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF4A4D4D),
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
              letterSpacing: 0.27,
            ),
          ),
        ],
      ),
    );
  }
}

class MeetTeam extends StatelessWidget {
  const MeetTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 20,
      children: [
        Text(
          'MEET OUR DEDICATED TEAM',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 19.24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.20,
            letterSpacing: 1.46,
          ),
        ),
        Text(
          'Florida Focused — Local knowledge, regional exposure, and access to the largest boating community in the U.S. Premium Listings - From sleek center consoles to luxury motor yachts, every vessel is showcased to attract the right buyer. Verified Sellers — We partner only with reputable owners, brokers, and dealerships for total peace of mind. Seamless Experience — Powerful search tools, clear pricing, and no hidden fees — just smooth transactions from start to finish.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF4A4D4D) /* grey-500 */,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
            letterSpacing: 0.35,
          ),
        ),
        Container(
          width: double.infinity,
          height: 135,
          decoration: ShapeDecoration(
            color: const Color(0xFFDCFCFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.77),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 2.26,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Builder(
                  builder: (context) {
                    final AboutUsController controller = Get.put(
                      AboutUsController(),
                    );
                    return Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 12.64,
                          children: controller.members
                              .map(
                                (m) => _TeamMember(
                                  member: m,
                                  avatarSize: m.avatarSize,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
