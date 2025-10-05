import 'package:diaz1234567890/core/utils/constants/imagepath.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/core/utils/constants/iconpath.dart';

import '../controller/home_controller.dart'; // 👈 import IconPath

class YachtHomePage extends StatelessWidget {
  final YachtController controller = Get.put(YachtController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Image Banner
              Stack(
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(Imagepath.homeBoat, fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Iconpath.customTune,
                            width: 25,
                            height: 25,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    "Find me a Viking for sale from 2005 to 2008",
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              foregroundColor: Colors.black,
                              elevation: 0, // 👈 no shadow
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  Iconpath.askAi,
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(width: 6),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  child: Text(
                                    "Ask AI",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Tab View (Categories)
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(controller.tabs.length, (index) {
                      bool isSelected = controller.selectedTab.value == index;
                      return GestureDetector(
                        onTap: () => controller.changeTab(index),
                        child: Container(
                          margin: EdgeInsets.only(right: 12),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.black : Colors.grey[100],
                            border: Border.all(
                              color: Colors.black,
                            ), // 👈 always black border
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.tabs[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
