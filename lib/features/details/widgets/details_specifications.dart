import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:diaz1234567890/features/details/model/boat_detail.dart';

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
                    _buildDetailRow('Listing ID', b?.listingId ?? ''),
                    _buildDetailRow('Brand Make', b?.make ?? ''),
                    _buildDetailRow('Model', b?.model ?? ''),
                    _buildDetailRow('Year', b?.buildYear?.toString() ?? ''),
                    _buildDetailRow('Class', b?.cLass ?? ''),
                    // Dimensions: prefer boatDimensions when available
                    _buildDetailRow(
                      'Length',
                      b?.boatDimensions != null
                          ? '${b!.boatDimensions!.lengthFeet ?? ''}\' ${b.boatDimensions!.lengthInches ?? ''}"'
                          : (b?.length?.toString() ?? ''),
                    ),
                    _buildDetailRow('Beam', b?.beam?.toString() ?? ''),
                    _buildDetailRow('Draft', b?.draft?.toString() ?? ''),
                    _buildDetailRow('Hull Material', b?.material ?? ''),
                    _buildDetailRow('Fuel Type', b?.fuelType ?? ''),
                    _buildDetailRow('Engine Type', b?.engineType ?? ''),
                    _buildDetailRow('Propeller Type', b?.propType ?? ''),
                    _buildDetailRow(
                      'Propeller Material',
                      b?.propMaterial ?? '',
                    ),
                    _buildDetailRow(
                      'Number Of Engines',
                      b?.enginesNumber?.toString() ?? '',
                    ),
                    _buildDetailRow(
                      'Number Of Cabins',
                      b?.cabinsNumber?.toString() ?? '',
                    ),
                    _buildDetailRow(
                      'Number Of Heads',
                      b?.headsNumber?.toString() ?? '',
                    ),
                    _buildDetailRow(
                      'Location',
                      b != null
                          ? '${b.city ?? ''}, ${b.state ?? ''} ${b.zip ?? ''}'
                          : '',
                    ),
                    // Per-engine details
                    if (b != null && b.engines.isNotEmpty) ...[
                      for (var i = 0; i < b.engines.length; i++) ...[
                        _buildDetailRow(
                          'Engine ${i + 1} Make',
                          b.engines[i].make ?? '',
                        ),
                        _buildDetailRow(
                          'Engine ${i + 1} Model',
                          b.engines[i].model ?? '',
                        ),
                        _buildDetailRow(
                          'Engine ${i + 1} Horsepower',
                          b.engines[i].horsepower?.toString() ?? '',
                        ),
                        _buildDetailRow(
                          'Engine ${i + 1} Hours',
                          b.engines[i].hours?.toString() ?? '',
                        ),
                        _buildDetailRow(
                          'Engine ${i + 1} Fuel Type',
                          b.engines[i].fuelType ?? '',
                        ),
                        _buildDetailRow(
                          'Engine ${i + 1} Propeller',
                          b.engines[i].propellerType ?? '',
                        ),
                      ],
                    ],
                    _buildDetailRow('Name', b?.name ?? ''),
                    _buildDetailRow('Condition', b?.condition ?? ''),
                    _buildDetailRow(
                      'Price',
                      b != null ? '\$${b.price.toString()}' : '',
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
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                color: const Color(0xFFEAEAEA),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                color: const Color(0xFFDBDBDB),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.black45, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
