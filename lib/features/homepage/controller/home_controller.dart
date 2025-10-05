import 'package:get/get.dart';

class YachtController extends GetxController {
  var selectedTab = 0.obs;

  List<String> tabs = ["All", "Centre Consoles", "Sportfish", "Luxury"];

  void changeTab(int index) {
    selectedTab.value = index;
  }
}
