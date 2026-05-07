// ignore_for_file: avoid_print


import 'package:diaz1234567890/features/blog/model/blog_model.dart';
import 'package:diaz1234567890/features/blog/service/blog_service.dart';
import 'package:get/get.dart';

class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String imagePath;
  final String imageUrl;
  final String readTime;
  final String date;

  BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.imagePath,
    required this.imageUrl,
    required this.readTime,
    required this.date,
  });

  // Convert Blog model to BlogPost
  factory BlogPost.fromBlog(Blog blog) {
    final readTimeStr = '${blog.readTime} min read';
    final dateStr = _formatDate(blog.createdAt);

    return BlogPost(
      id: blog.id,
      title: blog.blogTitle,
      excerpt: blog.blogDescription,
      imagePath: '', // Empty for network images
      imageUrl: blog.blogImage?.url ?? '',
      readTime: readTimeStr,
      date: dateStr,
    );
  }

  static String _formatDate(DateTime date) {
    final months = [
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

class BlogController extends GetxController {
  final RxList<BlogPost> posts = <BlogPost>[].obs; // All posts from API
  final RxList<BlogPost> displayedPosts =
      <BlogPost>[].obs; // Posts currently displayed (1 featured + up to 9)
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final Rx<String?> errorMessage = Rx<String?>(null);
  final RxBool hasMorePosts = false.obs;

  static const int itemsPerPage = 9;

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final List<Blog> blogs = await BlogService.fetchBlogs();
      final List<BlogPost> blogPosts = blogs
          .map((blog) => BlogPost.fromBlog(blog))
          .toList();

      posts.value = blogPosts;

      // Load initial batch: 1 featured + 9 items = 10 total
      _updateDisplayedPosts();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _updateDisplayedPosts() {
    // Featured blog (index 0) + next itemsPerPage items (1-9)
    final endIndex = itemsPerPage + 1; // 1 featured + 9 items
    if (posts.length > endIndex) {
      displayedPosts.value = posts.sublist(0, endIndex);
      hasMorePosts.value = true;
    } else {
      displayedPosts.value = posts;
      hasMorePosts.value = false;
    }
  }

  Future<void> loadMoreBlogs() async {
    try {
      print('🟣 [BlogController] Loading more blogs...');
      isLoadingMore.value = true;

      // Add next batch of items
      final currentCount = displayedPosts.length;
      final nextEndIndex = currentCount + itemsPerPage;

      if (nextEndIndex >= posts.length) {
        // Add remaining posts
        displayedPosts.value = posts;
        hasMorePosts.value = false;
        print(
          '🟣 [BlogController] Loaded remaining blogs. Total now: ${displayedPosts.length}',
        );
      } else {
        // Add next batch
        displayedPosts.value = posts.sublist(0, nextEndIndex);
        hasMorePosts.value = true;
        print(
          '🟣 [BlogController] Loaded batch. Total now: ${displayedPosts.length}',
        );
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('🔴 [BlogController] Error loading more blogs: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
}
