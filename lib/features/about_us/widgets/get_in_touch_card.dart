// ignore_for_file: avoid_print

import 'package:diaz1234567890/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetInTouchCard extends StatelessWidget {
  final RxString address;
  final RxString email;
  final RxString phone;
  final RxMap<String, String> socialMedia;
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
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 195,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(1.00, 0.50),
              end: Alignment(-0.00, 0.50),
              colors: [const Color(0xFF00CABE), const Color(0xFF006EF0)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 7.65,
              children: [
                Text(
                  'Address:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.5,
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 12),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 190),
                        child: Text(
                          address.value.isEmpty ? '' : address.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Email:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.5,
                    children: [
                      Icon(Icons.email, color: Colors.white, size: 12),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 190),
                        child: Text(
                          email.value.isEmpty
                              ? 'monica@floridayachttrader.com'
                              : email.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Call:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.5,
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 12),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 190),
                        child: Text(
                          phone.value.isEmpty ? '' : phone.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4.59,
                    children: [
                      if (socialMedia['facebook']?.isNotEmpty ?? false)
                        GestureDetector(
                          onTap: () => _launchUrl(socialMedia['facebook']!),
                          child: Container(
                            width: 15,
                            height: 15,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset(Iconpath.facebookIcon),
                          ),
                        ),
                      if (socialMedia['linkedin']?.isNotEmpty ?? false)
                        GestureDetector(
                          onTap: () => _launchUrl(socialMedia['linkedin']!),
                          child: Container(
                            width: 15,
                            height: 15,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset(Iconpath.instagramIcon),
                          ),
                        ),
                      if (socialMedia['twitter']?.isNotEmpty ?? false)
                        GestureDetector(
                          onTap: () => _launchUrl(socialMedia['twitter']!),
                          child: Container(
                            width: 15,
                            height: 15,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset(Iconpath.twitterIcon),
                          ),
                        ),
                      if (socialMedia['linkedin']?.isNotEmpty ?? false)
                        GestureDetector(
                          onTap: () => _launchUrl(socialMedia['linkedin']!),
                          child: Container(
                            width: 15,
                            height: 15,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset(Iconpath.linkedinIcon),
                          ),
                        ),
                      if (socialMedia['youtube']?.isNotEmpty ?? false)
                        GestureDetector(
                          onTap: () => _launchUrl(socialMedia['youtube']!),
                          child: Container(
                            width: 15,
                            height: 15,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Image.asset(Iconpath.youtubeIcon),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 35,
          child: Obx(
            () => Container(
              width: 150,
              height: 126,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: backgroundImageUrl.value.isNotEmpty
                      ? NetworkImage(backgroundImageUrl.value) as ImageProvider
                      : Image.asset('').image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    print('Opening: $url');
  }
}
