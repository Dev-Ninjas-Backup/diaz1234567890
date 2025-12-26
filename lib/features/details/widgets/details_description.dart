import 'package:diaz1234567890/features/details/widgets/details_expansion_tile.dart';
import 'package:flutter/material.dart';

class DetailsDescription extends StatelessWidget {
  const DetailsDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Note: ONLY 1600 HOURS WITH EXTENDED WARRANTY UNTIL MAY 2025 OR 2700 HOURS',
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
          ),
          const SizedBox(height: 6),
          const Text(
            '"On The Edge" is a highly custom Viking 80\' Enclosed Skybridge and is truly one of a kind! Some of her customizations are noted below, but will not compare to getting aboard and appreciating this build for yourself.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem(
            'Additional 450 gallons of fuel for a total of 3,682',
          ),
          _buildFeatureItem('Furuno Omni Sonar - Seakeeper 35 2021'),
          _buildFeatureItem(
            'Skybridge with custom hardtop, helm has ( 2 ) release chairs',
          ),
          _buildFeatureItem(
            'Day head located as you walk in on the starboard side',
          ),
          _buildFeatureItem('Custom rod room'),
          _buildFeatureItem('Custom stairs to enclosed flybridge'),
          _buildFeatureItem('Starboard aft stateroom, custom ( 4 ) bunks'),
          _buildFeatureItem(
            'Port stateroom VIP with electrically operated split berths accommodations',
          ),
          _buildFeatureItem('Raised panel doors on galley cabinets'),
          _buildFeatureItem(
            'Skybridge flooring is level, has custom sink and microwave cabinet',
          ),
          _buildFeatureItem('Pocket door on starboard head in companionway'),
          _buildFeatureItem('Master stateroom berth levels electronically'),
          _buildFeatureItem('Amazing AME Electronics package'),
          _buildFeatureItem(
            '( 2 ) of everything separated with own batteries and charging system',
          ),
          _buildFeatureItem('Custom storage throughout boat'),
          const SizedBox(height: 8),
          const DetailsExpansionTileList(),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 11, height: 1.1),
            ),
          ),
        ],
      ),
    );
  }
}
