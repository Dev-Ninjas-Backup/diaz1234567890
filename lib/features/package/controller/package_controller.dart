import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/package_model.dart';

class SellPackageController extends GetxController {
  var selectedPackage = ''.obs;
  var selectedBoatType = RxnString();

  final List<String> year = ['2021', '2022', '2023', '2024', '2025'];

  void selectBoatType(String? type) {
    selectedBoatType.value = type;
  }

  final List<PackageModel> packages = [
    PackageModel(
      title: "Gold Package",
      price: "\$9.99 /month",
      features: [
        "List in minutes!",
        "Fast, affordable, effective",
        "Enjoy Global Package Maximum Exposure",
        "No social media drama, just real buyers",
        "Show ads and boost potential",
        "10 instant FREE VIP promo code",
        "No overlay on your boat card",
      ],
      color: Colors.grey,
      buttonColor: Colors.grey,
    ),
    PackageModel(
      title: "Platinum Package",
      price: "\$15.99 /month",
      features: [
        "List in minutes!",
        "Fast, affordable, effective",
        "See 10x more views, more opportunity",
        "No social media drama, just real buyers",
        "Show ads and boost potential",
        "10 instant FREE VIP promo code",
        "No overlay on your boat card",
      ],
      tag: "Most Popular",
      color: Colors.white,
      buttonColor: Color(0xFF006EF0),
    ),
    PackageModel(
      title: "Diamond Elite Brokerage",
      price: "\$29.99 /month",
      features: [
        "Broker & Pro Sales Agents",
        "Fast, affordable, effective",
        "Enhance your insights under one package",
        "Welcome to top-tier network, board, and buyers",
        "Show ads and boost potential",
        "10 instant FREE VIP promo code",
        "No overlay on your boat card",
      ],
      color: Colors.grey,
      buttonColor: Colors.grey,
    ),
  ];

  void selectPackage(String title) {
    selectedPackage.value = title;
  }
}
