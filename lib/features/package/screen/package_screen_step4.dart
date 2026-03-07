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
        // padding: EdgeInsetsGeometry.only(
        //   top: 25,
        //   left: 26,
        //   right: 26,
        //   bottom: 25,
        // ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                            // Boat listing already created in Step 2
                            // Just show payment form if setup intent is ready
                            if (controller
                                .setupIntentClientSecret
                                .value
                                .isNotEmpty) {
                              setState(() {
                                _showPaymentSection = true;
                              });
                            } else {
                              // Setup intent not available, try to fetch it
                              controller.isLoading.value = true;
                              try {
                                await controller.fetchSetupIntentForPayment();
                                if (controller
                                    .setupIntentClientSecret
                                    .value
                                    .isNotEmpty) {
                                  setState(() {
                                    _showPaymentSection = true;
                                  });
                                } else {
                                  Get.snackbar(
                                    'Payment Setup Failed',
                                    'Could not initialize payment. Please try again.',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                }
                              } catch (e) {
                                Get.snackbar(
                                  'Payment Setup Failed',
                                  'Error: $e',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } finally {
                                controller.isLoading.value = false;
                              }
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
          if (controller.promoCode.value.isNotEmpty) ...[
            Divider(height: 16),
            _summaryRow('Promo Code', controller.promoCode.value, isBold: true),
          ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Card Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // ✅ IMPORTANT: No small fixed height
          CardFormField(
            controller: controller.cardFormEditController,
            style: CardFormStyle(
              backgroundColor: Colors.white,
              borderColor: Colors.grey.shade300,
              borderRadius: 12,
              borderWidth: 1,
              textColor: Colors.black,
              placeholderColor: Colors.grey.shade500,
              fontSize: 14,
            ),
            // onFormComplete: () {
            //   print("✅ Card form complete");
            // },
            onCardChanged: (card) {
              print("Brand: ${card?.brand}");
            },
          ),

          const SizedBox(height: 16),

          // 🔒 Security Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment information is secured with Stripe encryption',
                    style: TextStyle(fontSize: 12, color: Colors.blue.shade700),
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
