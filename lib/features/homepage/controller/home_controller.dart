import 'package:get/get.dart';

import '../../../core/utils/constants/imagepath.dart';
import '../model/home_model.dart';

class YachtController extends GetxController {
  var selectedTab = 0.obs;

  List<String> tabs = ["All", "Centre Consoles", "Sportfish", "Luxury"];

  void changeTab(int index) {
    selectedTab.value = index;
  }
}

class YachtListingController extends GetxController {
  var featuredYachts = <Yacht>[].obs;
  var premiumDeals = <Yacht>[].obs;

  @override
  void onInit() {
    super.onInit();

    featuredYachts.value = [
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
    ];

    premiumDeals.value = [
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
    ];
  }
}
