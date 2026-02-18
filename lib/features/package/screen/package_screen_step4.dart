import 'package:diaz1234567890/core/common/widget/custom_app_bar.dart';
import 'package:diaz1234567890/core/common/widget/custom_button.dart';
import 'package:diaz1234567890/features/package/controller/package_controller.dart';
import 'package:diaz1234567890/features/package/widgets/listing_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class PackageScreenStep4 extends StatefulWidget {
  const PackageScreenStep4({super.key});

  @override
  State<PackageScreenStep4> createState() => _PackageScreenStep4State();
}

class _PackageScreenStep4State extends State<PackageScreenStep4> {
  late SellPackageController controller;
  bool _showPaymentSection = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SellPackageController>();
  }

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
        child: SingleChildScrollView(
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
                _showPaymentSection ? 'Complete Payment' : 'Preview Listing',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 25),
              if (!_showPaymentSection) ...[
                // Listing Preview Section
                Obx(
                  () => Center(
                    child: ListingPreviewCard(
                      boatName: controller.nameController.text,
                      boatYear: controller.selectedBuildYear.value,
                      boatMake: controller.selectedMake.value,
                      boatModel: controller.modelController.text,
                      price: controller.priceController.text,
                      location:
                          '${controller.boatCityController.text.trim()}, ${controller.selectedBoatState.value ?? ''}',
                      coverImagePath: controller.coverImage.value?.path,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => CustomButton(
                    label: controller.isLoading.value
                        ? "Processing..."
                        : "Continue to payment →",
                    onPressed: controller.isLoading.value
                        ? () {}
                        : () async {
                            await controller.submitBoatOnboarding();
                            if (controller
                                .setupIntentClientSecret
                                .value
                                .isNotEmpty) {
                              setState(() {
                                _showPaymentSection = true;
                              });
                            }
                          },
                    width: double.infinity,
                  ),
                ),
              ] else ...[
                // Payment Section
                _buildPaymentSummary(),
                SizedBox(height: 20),
                _buildPaymentForm(),
                SizedBox(height: 20),
                Column(
                  children: [
                    Obx(
                      () => CustomButton(
                        label: controller.isLoading.value
                            ? "Processing..."
                            : "Confirm Payment →",
                        onPressed: controller.isLoading.value
                            ? () {}
                            : () async {
                                await controller.confirmPayment();
                              },
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: 12),
                    CustomButton(
                      label: "Back",
                      onPressed: () {
                        setState(() {
                          _showPaymentSection = false;
                        });
                      },
                      width: double.infinity,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          _summaryRow('Boat Listing', controller.nameController.text),
          Divider(height: 16),
          _summaryRow(
            'Subscription Plan',
            controller.selectedPackage.value,
            isBold: true,
          ),
          Divider(height: 16),
          _summaryRow('Plan Amount', _getPlanPrice(), isBold: true),
          Divider(height: 16),
          _summaryRow('Listing ID', controller.listingId.value),
        ],
      ),
    );
  }

  String _getPlanPrice() {
    try {
      final selectedId = controller.selectedPackageId.value;
      if (selectedId.isEmpty) return '-';

      final package = controller.packages.firstWhereOrNull(
        (pkg) => pkg.id == selectedId,
      );

      if (package != null) {
        return '\$${package.price.toStringAsFixed(2)}';
      }
      return '-';
    } catch (e) {
      return '-';
    }
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }

  Widget _buildPaymentForm() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
          // Card Number Field
          Text(
            'Card Number',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 6),
          CardField(
            onCardChanged: (card) {
              print('[CardField] Card changed: complete=${card?.complete}');
              print('[CardField] Card brand: ${card?.brand}');
              controller.cardFieldInputDetails.value = card;
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.credit_card, color: Colors.blue),
              hintText: '0000 0000 0000 0000',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_outline, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment information is secured with Stripe encryption',
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade900),
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
