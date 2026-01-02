// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class PackageModel {
  final String id;
  final String title;
  final String planType;
  final String description;
  final List<String> benefits;
  final int picLimit;
  final int wordLimit;
  final bool isBest;
  final bool isActive;
  final String stripeProductId;
  final String stripePriceId;
  final String currency;
  final double price;
  final int billingPeriodMonths;
  final String createdAt;
  final String updatedAt;

  // UI properties
  late final Color color;
  late final Color buttonColor;
  late final String? tag;

  PackageModel({
    required this.id,
    required this.title,
    required this.planType,
    required this.description,
    required this.benefits,
    required this.picLimit,
    required this.wordLimit,
    required this.isBest,
    required this.isActive,
    required this.stripeProductId,
    required this.stripePriceId,
    required this.currency,
    required this.price,
    required this.billingPeriodMonths,
    required this.createdAt,
    required this.updatedAt,
  }) {
    // Set UI properties based on plan type
    tag = isBest ? "Most Popular" : null;

    switch (planType) {
      case 'GOLD':
        color = Colors.amber.withOpacity(0.1);
        buttonColor = Colors.amber;
        break;
      case 'PLATINUM':
        color = Colors.white;
        buttonColor = const Color(0xFF006EF0);
        break;
      case 'DIAMOND':
        color = Colors.cyan.withOpacity(0.1);
        buttonColor = Colors.cyan;
        break;
      default:
        color = Colors.grey.withOpacity(0.1);
        buttonColor = Colors.grey;
    }
  }

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      planType: json['planType'] as String,
      description: json['description'] as String,
      benefits: List<String>.from(json['benefits'] as List),
      picLimit: json['picLimit'] as int,
      wordLimit: json['wordLimit'] as int,
      isBest: json['isBest'] as bool,
      isActive: json['isActive'] as bool,
      stripeProductId: json['stripeProductId'] as String,
      stripePriceId: json['stripePriceId'] as String,
      currency: json['currency'] as String,
      price: (json['price'] as num).toDouble(),
      billingPeriodMonths: json['billingPeriodMonths'] as int,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}
