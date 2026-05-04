// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants/icon_path.dart';

class GetInTouchCard extends StatelessWidget {
  final RxString address;
  final RxString email;
  final RxString phone;
  final RxMap<String, dynamic> socialMedia;
  final RxString backgroundImageUrl;

  const GetInTouchCard({
    super.key,
    required this.address,
    required this.email,
    required this.phone,
    required this.socialMedia,
    required this.backgroundImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 188),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: backgroundImageUrl.value.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(backgroundImageUrl.value),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.5),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: const Color(0xFF006EF0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Address:'),
              _buildValueRow(Icons.location_on, address.value),
              const SizedBox(height: 10),

              _buildLabel('Email:'),
              _buildValueRow(Icons.email, email.value),
              const SizedBox(height: 10),

              _buildLabel('Call:'),
              _buildValueRow(Icons.phone, phone.value),
              const SizedBox(height: 15),

              // Social Media Icons
              _buildSocialRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildValueRow(IconData icon, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value.isEmpty ? "Not Available" : value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRow() {
    // We access socialMedia.values to tell Obx to watch for changes inside the map
    if (socialMedia.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 10,
      children: [
        if (socialMedia.containsKey('facebook'))
          _socialIcon(Iconpath.facebookIcon, socialMedia['facebook']),
        if (socialMedia.containsKey('twitter'))
          _socialIcon(Iconpath.twitterIcon, socialMedia['twitter']),
        if (socialMedia.containsKey('linkedin'))
          _socialIcon(Iconpath.linkedinIcon, socialMedia['linkedin']),
        if (socialMedia.containsKey('youtube'))
          _socialIcon(Iconpath.youtubeIcon, socialMedia['youtube']),
        if (socialMedia.containsKey('instagram'))
          _socialIcon(Iconpath.instagramIcon, socialMedia['instagram']),
      ],
    );
  }

  Widget _socialIcon(String assetPath, dynamic url) {
    if (url == null || url.toString().isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => print("Opening: $url"),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          assetPath,
          width: 18,
          height: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
