import 'package:get/get.dart';
import 'package:diaz1234567890/core/utils/constants/image_path.dart';

class DetailsController extends GetxController {
  final currentIndex = 0.obs;

  final images = [Imagepath.ship2, Imagepath.ship1, Imagepath.ship2];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
