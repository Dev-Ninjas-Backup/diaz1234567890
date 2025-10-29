import 'package:get/get.dart';

class ProfileController extends GetxController {
  final privacyToggle = false.obs;
  final notificationToggle = true.obs;

  void togglePrivacy() => privacyToggle.value = !privacyToggle.value;
  void toggleNotification() =>
      notificationToggle.value = !notificationToggle.value;
}
