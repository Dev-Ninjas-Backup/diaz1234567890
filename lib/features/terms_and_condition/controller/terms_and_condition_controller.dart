import 'package:diaz1234567890/features/terms_and_condition/service/terms_and_condition_service.dart';
import 'package:get/get.dart';

class TermsAndConditionController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = RxnString();
  var title = "".obs;
  var description = "".obs;
  final TermsAndConditionService _service = TermsAndConditionService();

  @override
  void onInit() {
    getTerms();
    super.onInit();
  }

  void getTerms() async {
    try {
      isLoading(true);
      errorMessage.value = null;
      var data = await _service.fetchTerms();
      if (data != null) {
        title.value = data['termsTitle'] ?? "Terms and Condition";
        description.value = data['termsDescription'] ?? "";
      } else {
        errorMessage.value = "Failed to load content";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading(false);
    }
  }
}