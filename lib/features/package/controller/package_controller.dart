import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/package_model.dart';

class SellPackageController extends GetxController {
  var selectedPackage = ''.obs;

  // Specifications
  var selectedBoatType = RxnString();
  var selectedMake = RxnString();
  var selectedClass = RxnString();
  var selectedMaterial = RxnString();
  var selectedFuelType = RxnString();
  var selectedNumberOfEngine = RxnString();
  var selectedNumberOfCabin = RxnString();
  var selectedNumberOfHeads = RxnString();

  final List<String> year = ['2021', '2022', '2023', '2024', '2025'];
  final List<String> make = ['Yamaha', 'Sea Ray', 'Bayliner'];
  final List<String> boatClass = ['Class A', 'Class B', 'Class C'];
  final List<String> material = ['Fiberglass', 'Aluminum', 'Steel'];
  final List<String> fuelType = ['Gasoline', 'Diesel', 'Electric'];
  final List<String> numberOfEngines = ['1', '2', '3+'];
  final List<String> numberOfCabins = ['1', '2', '3+'];
  final List<String> numberOfHeads = ['1', '2', '3+'];

  void selectBoatType(String? type) {
    selectedBoatType.value = type;
  }

  void selectMake(String? value) {
    selectedMake.value = value;
  }

  void selectClass(String? value) {
    selectedClass.value = value;
  }

  void selectMaterial(String? value) {
    selectedMaterial.value = value;
  }

  void selectFuelType(String? value) {
    selectedFuelType.value = value;
  }

  void selectNumberOfEngine(String? value) {
    selectedNumberOfEngine.value = value;
  }

  void selectNumberOfCabin(String? value) {
    selectedNumberOfCabin.value = value;
  }

  void selectNumberOfHeads(String? value) {
    selectedNumberOfHeads.value = value;
  }

  // Engine
  var selectedEngineFuelType = RxnString();
  var selectedPropellerType = RxnString();

  final List<String> propellerType = ['Propeller A', 'Propeller B'];

  void selectEngineFuelType(String? value) {
    selectedEngineFuelType.value = value;
  }

  void selectPropellerType(String? value) {
    selectedPropellerType.value = value;
  }

  // Contact Details
  var selectedCountry = RxnString();
  var selectedCity = RxnString();
  var selectedState = RxnString();

  final List<String> countries = ['USA', 'Canada', 'UK'];
  final List<String> cities = ['New York', 'Los Angeles', 'Toronto'];
  final List<String> states = ['California', 'New York', 'Ontario'];

  void selectCountry(String? value) {
    selectedCountry.value = value;
  }

  void selectCity(String? value) {
    selectedCity.value = value;
  }

  void selectState(String? value) {
    selectedState.value = value;
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
