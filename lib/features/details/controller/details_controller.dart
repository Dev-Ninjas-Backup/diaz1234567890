import 'package:diaz1234567890/core/utils/constants/image_path.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  var currentIndex = 0.obs;

  // ডামি ইমেজ লিস্ট
  final List<String> images = [
    Imagepath.ship1,
    Imagepath.ship2,
    Imagepath.room1,
    Imagepath.room2,
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
