import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../model/home_model.dart';

class YachtListingPage extends StatelessWidget {
  final YachtListingController controller = Get.put(YachtListingController());

  YachtListingPage({super.key});

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(height: 20),

        SizedBox(
          height: 340,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 16),
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
                            Divider(),

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
            buildSection("Featured Yacht", controller.featuredYachts),
            SizedBox(height: 20),
            buildSection("Premium Deals", controller.premiumDeals),
            SizedBox(height: 20),
            buildSection("Centre Consoles", controller.premiumDeals),
            SizedBox(height: 20),
            buildSection("Sportfish", controller.premiumDeals),
            SizedBox(height: 20),
            buildSection("Luxury Yachts", controller.premiumDeals),
            SizedBox(height: 20),
            buildSection("Catamarans", controller.premiumDeals),
            SizedBox(height: 20),
            buildSection("Cruisers", controller.premiumDeals),
            SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(Imagepath.homeBoat),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.35),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Looking to Sell Your Boat?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Showcasing the finest yachts from our trusted network.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            // ignore: deprecated_member_use
                            backgroundColor: Colors.black.withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),

                          label: const Text(
                            "List Your Yacht",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
