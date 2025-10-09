import 'package:flutter/material.dart';

class PackageModel {
  final String title;
  final String price;
  final List<String> features;
  final String? tag;
  final Color color;
  final Color buttonColor;

  PackageModel({
    required this.title,
    required this.price,
    required this.features,
    this.tag,
    required this.color,
    required this.buttonColor,
  });
}
