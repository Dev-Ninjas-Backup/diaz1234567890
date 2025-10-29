import 'package:get/get.dart';

import '../../../core/utils/constants/image_path.dart';
import '../model/yacht_model.dart';

class YachtSearchListingController extends GetxController {
  var similarYachts = <Yacht>[].obs;

  @override
  void onInit() {
    super.onInit();

    similarYachts.value = [
      Yacht(
        title: "2024 SeaVee 370z",
        location: "Florida",
        make: "Mercury",
        model: "Volvo",
        year: "2008",
        price: "\$1,195,000",
        image: Imagepath.singleBoat,
      ),
      Yacht(
        title: "2007 Hatteras GT",
        location: "Florida",
        make: "Mercury",
        model: "Volvo",
        year: "2007",
        price: "\$1,195,000",
        image: Imagepath.singleBoat,
      ),
      Yacht(
        title: "2024 SeaVee 370z",
        location: "Florida",
        make: "Mercury",
        model: "Volvo",
        year: "2008",
        price: "\$1,195,000",
        image: Imagepath.singleBoat,
      ),
    ];
  }
}
