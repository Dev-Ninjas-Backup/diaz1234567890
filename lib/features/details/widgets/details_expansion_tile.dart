import 'package:flutter/material.dart';
//import 'package:diaz1234567890/features/details/controller/details_controller.dart';

class DetailsExpansionTileList extends StatelessWidget {
  const DetailsExpansionTileList({super.key});

  @override
  Widget build(BuildContext context) {
    // This widget is static for now. If gallery images or other observable
    // values need to be used here in the future, wrap only those specific
    // parts in Obx/GetX. Using Obx for the whole widget when no observables
    // are read causes the GetX improper use error.

    return Column(
      children: [
        const _ExpansionTileWithScale(title: 'Information & features'),
        const _ExpansionTileWithScale(title: 'Accommodations'),
        const _ExpansionTileWithScale(title: 'Salon'),
        const _ExpansionTileWithScale(title: 'Salon Day Head'),
        // Galley tile - show gallery images from API (handled separately)
        const _ExpansionTileWithScale(title: 'Galley'),
        const _ExpansionTileWithScale(title: 'Companionway'),
        const _ExpansionTileWithScale(title: 'Master Stateroom'),
        const _ExpansionTileWithScale(title: 'Master Head'),
        const _ExpansionTileWithScale(title: 'Forward Stateroom'),
        const _ExpansionTileWithScale(title: 'Forward Stateroom Head'),
        const _ExpansionTileWithScale(title: 'Port Stateroom Head'),
        const _ExpansionTileWithScale(title: 'Starboard Stateroom'),
        const _ExpansionTileWithScale(title: 'Starboard Aft Stateroom'),
        const _ExpansionTileWithScale(title: 'Crew Quarters'),
        const _ExpansionTileWithScale(title: 'Crew Head'),
        const _ExpansionTileWithScale(title: "Cockpit"),
        const _ExpansionTileWithScale(title: 'Flybridge'),
        const _ExpansionTileWithScale(title: 'Electronics & Navigation'),
        const _ExpansionTileWithScale(title: 'Deck & Hull'),
        const _ExpansionTileWithScale(title: 'Mechanical'),
        const _ExpansionTileWithScale(title: 'Engine Room'),
        const _ExpansionTileWithScale(title: 'Disclaimer'),
        const _ExpansionTileWithScale(title: 'Starboard Head'),
      ],
    );
  }
}

class _ExpansionTileWithScale extends StatelessWidget {
  final String title;
  const _ExpansionTileWithScale({required this.title});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Divider(color: Colors.grey.shade300, height: 1),
          ],
        ),
        //children: children,
      ),
    );
  }
}
