
import 'package:diaz1234567890/features/about_us/model/mission_vision_model.dart';
import 'package:diaz1234567890/features/about_us/service/mission_vision_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class MissionVisionSection extends StatefulWidget {
  const MissionVisionSection({super.key});

  @override
  State<MissionVisionSection> createState() => _MissionVisionSectionState();
}

class _MissionVisionSectionState extends State<MissionVisionSection> {
  late final Rxn<MissionVision> missionVision = Rxn<MissionVision>();
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  @override
  void initState() {
    super.initState();
    _fetchMissionVision();
  }

  Future<void> _fetchMissionVision() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final data = await MissionVisionService.fetchMissionVision();
      missionVision.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (errorMessage.value != null) {
        return Center(
          child: Text(
            'Error: ${errorMessage.value}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }

      final mv = missionVision.value;
      if (mv == null) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'OUR STORY',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 19.24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.20,
                letterSpacing: 1.46,
              ),
            ),
          ),
          SizedBox(height: 8),
          Html(data: mv.description),
          SizedBox(height: 31),
          Text(
            mv.missionTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          SizedBox(height: 4),
          Html(data: mv.description),
          SizedBox(height: 18),
          Text(
            mv.visionTitle,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.50,
            ),
          ),
          SizedBox(height: 4),
          Html(data: mv.visionDescription),
          SizedBox(height: 40),
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // 1. LEFT IMAGE (Background layer)
                Positioned(
                  left: 35.83,
                  child: mv.image1?.url.isNotEmpty == true
                      ? Container(
                          width: 115,
                          height: 126,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(mv.image1!.url),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.62),
                            ),
                          ),
                        )
                      : Container(
                          width: 115,
                          height: 126,
                          decoration: ShapeDecoration(
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.62),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                ),

                // 2. CENTER IMAGE (Middle layer)
                Positioned(
                  top: 0,
                  child: mv.image2?.url.isNotEmpty == true
                      ? Container(
                          width: 143.69,
                          height: 160.08,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(mv.image2!.url),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.62),
                            ),
                          ),
                        )
                      : Container(
                          width: 143.69,
                          height: 160.08,
                          decoration: ShapeDecoration(
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.62),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 35,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                ),

                // 3. RIGHT IMAGE (Top layer - highest)
                Positioned(
                  right: 35.83,
                  child: mv.image3?.url.isNotEmpty == true
                      ? Container(
                          width: 115,
                          height: 126,
                          decoration: ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(mv.image3!.url),
                              fit: BoxFit.cover,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.62),
                            ),
                          ),
                        )
                      : Container(
                          width: 115,
                          height: 126,
                          decoration: ShapeDecoration(
                            color: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.62),
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
