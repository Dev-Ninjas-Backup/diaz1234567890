import 'package:flutter/material.dart';

class DetailsExpansionTileList extends StatelessWidget {
  const DetailsExpansionTileList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ExpansionTileWithScale(title: 'Information & features'),
        _ExpansionTileWithScale(title: 'Accommodations'),
        _ExpansionTileWithScale(title: 'Salon'),
        _ExpansionTileWithScale(title: 'Salon Day Head'),
        _ExpansionTileWithScale(title: 'Galley'),
        _ExpansionTileWithScale(title: 'Companionway'),
        _ExpansionTileWithScale(title: 'Master Stateroom'),
        _ExpansionTileWithScale(title: 'Master Head'),
        _ExpansionTileWithScale(title: 'Forward Stateroom'),
        _ExpansionTileWithScale(title: 'Forward Stateroom Head'),
        _ExpansionTileWithScale(title: 'Port Stateroom Head'),
        _ExpansionTileWithScale(title: 'Starboard Stateroom'),
        _ExpansionTileWithScale(title: 'Starboard Aft Stateroom'),
        _ExpansionTileWithScale(title: 'Crew Quarters'),
        _ExpansionTileWithScale(title: 'Crew Head'),
        _ExpansionTileWithScale(title: "Cockpit"),
        _ExpansionTileWithScale(title: 'Flybridge'),
        _ExpansionTileWithScale(title: 'Electronics & Navigation'),
        _ExpansionTileWithScale(title: 'Deck & Hull'),
        _ExpansionTileWithScale(title: 'Mechanical'),
        _ExpansionTileWithScale(title: 'Engine Room'),
        _ExpansionTileWithScale(title: 'Disclaimer'),
        _ExpansionTileWithScale(title: 'Starboard Head'),
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Divider(
              color: Colors.grey.shade300,
              height: 1,
            ),
          ],
        ),
        children: const <Widget>[],
      ),
    );
  }
}
