import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';

class DetailsSpecifications extends StatelessWidget {
  const DetailsSpecifications({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    return Obx(() {
      final b = controller.boat.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
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
                    _buildDetailRow('Brand Make', b?.make ?? ''),
                    _buildDetailRow('Model', b?.model ?? ''),
                    _buildDetailRow(
                      'Built Year',
                      b?.buildYear?.toString() ?? '',
                    ),
                    _buildDetailRow('Length', b?.length?.toString() ?? ''),
                    _buildDetailRow(
                      'Number of Engine',
                      b?.enginesNumber?.toString() ?? '',
                    ),
                    _buildDetailRow('Class', b?.cLass ?? ''),
                    _buildDetailRow('Material', b?.material ?? ''),
                    _buildDetailRow(
                      'Number of Cabin',
                      b?.cabinsNumber?.toString() ?? '02',
                    ),
                    _buildDetailRow(
                      'Number of Heads',
                      b?.headsNumber?.toString() ?? '',
                    ),
                    _buildDetailRow('Beam Size', b?.beam?.toString() ?? ''),
                    _buildDetailRow('Fuel Type', b?.make ?? ''),
                    _buildDetailRow(
                      'Max Draft',
                      b?.draft?.toString() ?? '5 ft',
                    ),
                    _buildDetailRow('Name', b?.name ?? ''),
                    _buildDetailRow(
                      'Location',
                      b != null ? '${b.city ?? ''}, ${b.state ?? ''}' : '',
                    ),
                    _buildDetailRow('Condition', b?.condition ?? ''),
                    _buildDetailRow(
                      'Price',
                      b != null ? '\$${b.price.toString()}' : '\$6,250,000',
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
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
              height: 30,
              color: const Color(0xFFEAEAEA),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 30,
              color: const Color(0xFFDBDBDB),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                value,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
