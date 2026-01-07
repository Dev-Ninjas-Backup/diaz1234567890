import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:diaz1234567890/features/profile/my_listing/model/boat.dart';
import 'package:diaz1234567890/features/profile/my_listing/controller/my_listing_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/routes/app_routes.dart';

class MyListingContainer extends StatelessWidget {
  final Boat? boat;

  const MyListingContainer({super.key, this.boat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to edit listing screen or perform desired action
        Get.toNamed(AppRoute.detailsScreen, arguments: boat!.id);
      },
      child: Container(
        margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      child: boat != null && boat!.coverImages.isNotEmpty
                          ? Image.network(
                              boat!.coverImages.first.url,
                              height: 98,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                Imagepath.ship1,
                                height: 98,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              Imagepath.ship1,
                              height: 98,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 5),
                          Text(
                            '${boat!.city}, ${boat!.state ?? 'Florida'}',
                            style: TextStyle(
                              color: AppColors.subTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        boat?.name ?? '2015 Lagoon 450 F Catamaran',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Make',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                boat?.make ?? 'Mercury',
                                style: TextStyle(
                                  color: AppColors.subTitle,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Model',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                boat?.model ?? 'Volvo',
                                style: TextStyle(
                                  color: AppColors.subTitle,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Year',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                boat?.buildYear?.toString() ?? '2008',
                                style: TextStyle(
                                  color: AppColors.subTitle,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Divider(),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Price: \$ ${boat != null ? boat!.price.toString() : '1,195,000'}',
                        style: TextStyle(
                          color: Color(0xFF00AC9D),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 53),
                  ],
                ),
              ),
            ),
            SizedBox(height: 13),
            Row(
              children: [
                Text(
                  'Edit',
                  style: TextStyle(
                    color: Color(0xFF00AC9D),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Color(0xFF00AC9D), size: 20),
                ),
                Spacer(),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Boat'),
          content: const Text(
            'Are you sure you want to delete this boat listing? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performDelete();
                Get.back();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _performDelete() {
    if (boat == null) return;

    final MyListingController controller = Get.find();
    final boatId = boat!.id.isNotEmpty ? boat!.id : boat!.listingId;
    controller.deleteBoat(boatId);
  }
}
