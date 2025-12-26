import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';

class DetailsThumbnailGallery extends StatelessWidget {
  const DetailsThumbnailGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 20, 26, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              Imagepath.room1,
              height: 152,
              width: 185,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  Imagepath.room2,
                  height: 71,
                  width: 128,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      Imagepath.room3,
                      height: 71,
                      width: 128,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 20,
                      width: 80,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'See All Photo',
                          style: TextStyle(
                            color: Color(0xFF006EF0),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
