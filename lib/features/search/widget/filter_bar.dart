// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class YachtFilterBar extends StatelessWidget {
  final Map<String, String> filters;

  const YachtFilterBar({super.key, required this.filters});

  // Example options for each filter - replace with your actual options
  static const Map<String, List<String>> _filterOptions = {
    "Year": ["2005", "2006", "2007", "2008", "2009", "2010+"],
    "Model": ["80 Enclosed", "75 Motor Yacht", "Open", "Convertible"],
    "Price": ["\$22,000", "\$50,000", "\$100,000", "\$200,000+"],
    "Boat Type": [
      "Flybridge",
      "Motor Yacht",
      "Sport Fishing",
      "Center Console",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: filters.entries.map((entry) {
          final String key = entry.key;
          final String currentValue = entry.value;
          final List<String> options = _filterOptions[key] ?? [currentValue];

          return Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: currentValue,
                icon: const SizedBox.shrink(), // Hide default icon
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    print("$key changed to $newValue");
                  }
                },
                selectedItemBuilder: (BuildContext context) {
                  return options.map<Widget>((String item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              key,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ), // Minimal gap between text and icon
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  }).toList();
                },
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
