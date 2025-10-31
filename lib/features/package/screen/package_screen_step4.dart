import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:flutter/material.dart';

class PackageScreenStep4 extends StatelessWidget {
  const PackageScreenStep4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Register Your Boat'),
      body: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 25,
          left: 26,
          right: 26,
          bottom: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Listing Progress",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Step 4",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Select Package",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Boat Information",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Seller Information",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 62,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Pay & Post",
                      style: TextStyle(fontSize: 8, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            Text(
              'Preview Listing',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: Image.asset(
                'assets/images/listingFrame.png',
                height: 360,
                width: 300,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              label: "Continue to payment →",
              onPressed: () {},
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
