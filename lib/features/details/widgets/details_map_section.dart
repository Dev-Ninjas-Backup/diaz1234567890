import 'package:flutter/material.dart';

class DetailsMapSection extends StatelessWidget {
  const DetailsMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Text("Location in Map",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            children: const [
              Icon(Icons.location_on_outlined, size: 20),
              SizedBox(width: 8),
              Text(
                "Montauk, NY",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 26),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Text("Map Placeholder")),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
