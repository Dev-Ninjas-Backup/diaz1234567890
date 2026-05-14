import 'package:flutter/material.dart';
import '../controller/about_us_controller.dart';

class MemberDetailsPopup extends StatelessWidget {
  final TeamMemberData member;

  const MemberDetailsPopup({super.key, required this.member});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            width: 338.01,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21.38),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 338.01,
                  height: 70.81,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.54, 1.00),
                      end: Alignment(0.54, -0.00),
                      colors: [
                        const Color(0xFF00CABE),
                        const Color(0xFF006EF0),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21.38),
                        topRight: Radius.circular(21.38),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 40.0,
                    right: 40.0,
                    bottom: 26,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 65),
                      Text(
                        'BIOGRAPHY',
                        style: TextStyle(
                          color: const Color(0xFF6C6F6F) /* grey-400 */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                          letterSpacing: 0.36,
                        ),
                      ),
                      Text(
                        member.description,
                        style: TextStyle(
                          color: const Color(0xFF4A4D4D) /* grey-500 */,
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: 0.47,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 26,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(member.imageUrl),
                ),
                Text(
                  member.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.14,
                  ),
                ),
                Text(
                  member.role,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF006EF0) /* secondary-400 */,
                    fontSize: 11,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: 0.36,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
