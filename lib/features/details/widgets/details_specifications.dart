import 'package:flutter/material.dart';

class DetailsSpecifications extends StatelessWidget {
  const DetailsSpecifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 26, vertical: 16),
          child: Text(
            'Specifications',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Column(
                children: [
                  _buildDetailRow('Brand Make', 'Viking'),
                  _buildDetailRow('Model', '80 Enclosed Skybridge'),
                  _buildDetailRow('Built Year', '2018'),
                  _buildDetailRow('Length', '80 ft'),
                  _buildDetailRow('Number of Engine', '02'),
                  _buildDetailRow('Class', 'Flybridge'),
                  _buildDetailRow('Material', 'Fiberglass'),
                  _buildDetailRow('Number of Cabin', '02'),
                  _buildDetailRow('Number of Heads', '05'),
                  _buildDetailRow('Beam Size', '21 ft 4 In'),
                  _buildDetailRow('Fuel Type', 'Diesel'),
                  _buildDetailRow('Max Draft', '5 ft 7 In'),
                  _buildDetailRow('Name', 'ON THE EDGE'),
                  _buildDetailRow('Location', 'Montauk, NY'),
                  _buildDetailRow('Condition', 'Used'),
                  _buildDetailRow('Price', '\$6,250,000', isLast: true),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              color: const Color(0xFFEAEAEA),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 20,
              color: const Color(0xFFDBDBDB),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black45, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
