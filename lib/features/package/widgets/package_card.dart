import 'package:flutter/material.dart';

import '../../../core/utils/constants/icon_path.dart';

class PackageCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;
  final Color buttonColor;
  final String? tag;

  const PackageCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.isSelected,
    required this.onTap,
    required this.color,
    required this.buttonColor,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Color(0xFF006EF0) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                  color: Color(0xFF10A8B1),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(),
              SizedBox(height: 10),
              for (var feature in features)
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(Iconpath.checkCircle, width: 18, height: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Color(0xFF006EF0)
                        : const Color.fromARGB(255, 212, 212, 212),
                    foregroundColor: isSelected ? Colors.white : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(isSelected ? "Selected" : "Select"),
                ),
              ),
            ],
          ),
        ),
        if (tag != null)
          Positioned(
            top: 10,
            right: -40,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                color: Colors.green,
                child: Text(
                  tag!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
