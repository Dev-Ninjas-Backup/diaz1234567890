
import 'package:diaz1234567890/features/blog_details/model/blog_details_model.dart';
import 'package:diaz1234567890/features/blog_details/service/blog_details_service.dart';
import 'package:get/get.dart';

class BlogDetailsController extends GetxController {
  final Rxn<BlogDetails> details = Rxn<BlogDetails>();
  final RxBool isLoading = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchBlogDetails();
  }

  Future<void> fetchBlogDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final String? blogId = _resolveBlogId();
      if (blogId == null || blogId.isEmpty) {
        throw Exception('Blog id is missing');
      }

      details.value = await BlogDetailsService.fetchBlogDetails(blogId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String? _resolveBlogId() {
    final dynamic args = Get.arguments;

    if (args is String) {
      return args;
    }

    if (args is Map<String, dynamic>) {
      return args['id']?.toString();
    }

    if (args is Map) {
      return args['id']?.toString();
    }

    return null;
  }

  String get title => details.value?.blogTitle ?? '';

  String get description => details.value?.blogDescription ?? '';

  String get imageUrl => details.value?.blogImage?.url ?? '';

  String get readTimeText => '${details.value?.readTime ?? 0} min read';

  String get dateText {
    final DateTime? date = details.value?.createdAt;
    if (date == null) {
      return '';
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
