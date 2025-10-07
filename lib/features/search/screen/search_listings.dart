import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/yacht_controller.dart';
import '../model/yacht_model.dart';

class YachtSearchListingPage extends StatelessWidget {
  final YachtSearchListingController controller = Get.put(
    YachtSearchListingController(),
  );

  YachtSearchListingPage({super.key});

  Widget _buildDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget buildSection(String title, List<Yacht> yachts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Discover the best yachts available right now. These are handpicked deals.",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),

        SizedBox(height: 10),

        SizedBox(
          height: 340,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            scrollDirection: Axis.horizontal,
            itemCount: yachts.length,
            itemBuilder: (context, index) {
              final yacht = yachts[index];
              return Container(
                width: 230,
                margin: EdgeInsets.only(right: 12, bottom: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Yacht Image
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.asset(
                        yacht.image,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  yacht.location,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              yacht.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 6),
                            Divider(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildDetail("Make", yacht.make),
                                _buildDetail("Model", yacht.model),
                                _buildDetail("Year", yacht.year),
                              ],
                            ),

                            Spacer(),
                            Text(
                              "Price: ${yacht.price}",
                              style: TextStyle(
                                color: Color(0xFF00A3AC),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            buildSection("120 Similar Listings", controller.similarYachts),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
