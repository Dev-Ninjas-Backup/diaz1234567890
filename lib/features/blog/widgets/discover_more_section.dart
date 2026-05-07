// ignore_for_file: deprecated_member_use

import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';

class DiscoverMoreSection extends StatelessWidget {
  const DiscoverMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 177,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(Imagepath.bottomImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 14,
        children: [
          Text(
            'WHERE LUXURY MEETS RELIABILITY',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white /* grey-base */,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 1.20,
              shadows: [
                Shadow(
                  offset: Offset(0, 0),
                  blurRadius: 11,
                  color: Color(0xFF000000).withOpacity(0.36),
                ),
              ],
            ),
          ),
          Text(
            'Showcasing the finest yachts from our trusted network.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white /* grey-base */,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFF101111) /* grey-700 */,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Discover more',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white /* grey-base */,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
