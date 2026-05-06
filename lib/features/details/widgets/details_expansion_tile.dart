import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diaz1234567890/features/details/controller/details_controller.dart';
import 'package:diaz1234567890/features/details/model/boat_detail.dart';

class DetailsExpansionTileList extends StatelessWidget {
  const DetailsExpansionTileList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DetailsController>();

    bool hasKeyword(BoatDetail? b, List<String> keywords) {
      if (b == null) return false;
      final desc = (b.description).toLowerCase();
      for (final k in keywords) {
        if (desc.contains(k)) return true;
      }
      for (final d in b.extraDetails) {
        final t = ('${d.title} ${d.description}').toLowerCase();
        for (final k in keywords) {
          if (t.contains(k)) return true;
        }
      }
      return false;
    }

    return Obx(() {
      final b = controller.boat.value;
      // ignore: unused_local_variable
      final imgs = controller.images;

      final sections = <Widget>[];

      // Information & features -> use extraDetails
      if (b?.extraDetails.isNotEmpty == true) {
        sections.add(
          _ExpansionTileWithScale(
            title: 'Information & features',
            children: b!.extraDetails
                .map(
                  (d) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    child: Text(d.description),
                  ),
                )
                .toList(),
          ),
        );
      }

      // Accommodations -> cabins
      if (b?.cabinsNumber != null && (b!.cabinsNumber ?? 0) > 0) {
        sections.add(
          _ExpansionTileWithScale(
            title: 'Accommodations',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Text('Cabins: ${b.cabinsNumber}'),
              ),
            ],
          ),
        );
      }

      // Galley -> if there are gallery images
      // if (imgs.isNotEmpty) {
      //   sections.add(
      //     _ExpansionTileWithScale(
      //       title: 'Galley',
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 12.0,
      //             vertical: 8.0,
      //           ),
      //           child: Text('Photos available: ${imgs.length}'),
      //         ),
      //       ],
      //     ),
      //   );
      // }

      // Electronics & Navigation -> keyword search
      // if (_hasKeyword(b, [
      //   'electronic',
      //   'gps',
      //   'radar',
      //   'chart',
      //   'raymarine',
      // ])) {
      //   sections.add(
      //     const _ExpansionTileWithScale(title: 'Electronics & Navigation'),
      //   );
      // }

      // // Deck & Hull
      // if (_hasKeyword(b, ['deck', 'hull', 'bow', 'stern', 'decking'])) {
      //   sections.add(const _ExpansionTileWithScale(title: 'Deck & Hull'));
      // }

      // Mechanical / Engine Room
      if (b?.enginesNumber != null && (b!.enginesNumber ?? 0) > 0) {
        sections.add(
          _ExpansionTileWithScale(
            title: 'Engine Room',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                child: Text('Engines: ${b.enginesNumber}'),
              ),
            ],
          ),
        );
      }

      // Disclaimer if description contains 'disclaimer'
      if (hasKeyword(b, ['disclaimer'])) {
        sections.add(const _ExpansionTileWithScale(title: 'Disclaimer'));
      }

      if (sections.isEmpty) return const SizedBox.shrink();

      return Column(children: sections);
    });
  }
}

class _ExpansionTileWithScale extends StatelessWidget {
  final String title;
  final List<Widget>? children;
  const _ExpansionTileWithScale({required this.title, this.children});

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
        children: children ?? [],
      ),
    );
  }
}
