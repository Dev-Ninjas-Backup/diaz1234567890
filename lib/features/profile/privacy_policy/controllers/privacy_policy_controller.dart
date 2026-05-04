import 'package:diaz1234567890/features/profile/privacy_policy/service/privacy_policy_service.dart';
import 'package:get/get.dart';

class PrivacyController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = "".obs;
  var privacyTitle = "".obs;
  var privacyDescription = "".obs;
  final PrivacyService _service = PrivacyService();

  @override
  void onInit() {
    getPrivacyPolicy();
    super.onInit();
  }

  void getPrivacyPolicy() async {
    try {
      isLoading(true);
      errorMessage("");
      var data = await _service.fetchPrivacyPolicy();
      if (data != null) {
        privacyTitle.value = data['privacyTitle'] ?? "";
        privacyDescription.value = data['privacyDescription'] ?? "";
      } else {
        errorMessage.value = "Failed to load privacy policy";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}