import 'package:diaz1234567890/core/utils/constants/app_colors.dart';
import 'package:diaz1234567890/features/blog/controller/blog_controller.dart';
import 'package:diaz1234567890/features/blog/widgets/blog_card.dart';
import 'package:diaz1234567890/features/blog/widgets/discover_more_section.dart';
import 'package:diaz1234567890/features/blog_details/controller/blog_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class BlogDetailsScreen extends StatelessWidget {
  BlogDetailsScreen({super.key});
  final BlogController controller = Get.put(BlogController());
  final BlogDetailsController detailsController = Get.put(
    BlogDetailsController(),
  );

  String _truncateText(String value, int limit) {
    if (value.length <= limit) {
      return value;
    }
    return '${value.substring(0, limit)}...';
  }

  Future<void> _launchAppOrWeb(Uri appUri, Uri webUri) async {
    try {
      final hasApp = await canLaunchUrl(appUri);
      if (hasApp) {
        final openedApp = await launchUrl(
          appUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (openedApp) {
          return;
        }
      }
    } catch (_) {}

    try {
      final hasWebHandler = await canLaunchUrl(webUri);
      if (hasWebHandler) {
        final openedInAppBrowser = await launchUrl(
          webUri,
          mode: LaunchMode.inAppBrowserView,
        );
        if (openedInAppBrowser) {
          return;
        }

        final openedInAppWebView = await launchUrl(
          webUri,
          mode: LaunchMode.inAppWebView,
        );
        if (openedInAppWebView) {
          return;
        }

        final openedDefault = await launchUrl(
          webUri,
          mode: LaunchMode.platformDefault,
        );
        if (openedDefault) {
          return;
        }
      }
    } catch (_) {}

    Get.snackbar(
      'Share failed',
      'No compatible app/browser found on this device.',
    );
  }

  Future<void> _shareOnWhatsApp(String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final appUri = Uri.parse('whatsapp://send?text=$encodedMessage');
    final webUri = Uri.parse('https://wa.me/?text=$encodedMessage');
    await _launchAppOrWeb(appUri, webUri);
  }

  Future<void> _shareOnFacebook(String shareUrl) async {
    final encodedUrl = Uri.encodeComponent(shareUrl);
    final webShareUrl =
        'https://www.facebook.com/sharer/sharer.php?u=$encodedUrl';
    final appUri = Uri.parse(
      'fb://facewebmodal/f?href=${Uri.encodeComponent(webShareUrl)}',
    );
    final webUri = Uri.parse(webShareUrl);
    await _launchAppOrWeb(appUri, webUri);
  }

  Future<void> _shareOnTwitter(String title, String shareUrl) async {
    final message = '$title $shareUrl';
    final encodedMessage = Uri.encodeComponent(message);
    final appUri = Uri.parse('twitter://post?message=$encodedMessage');
    final webUri = Uri.parse(
      'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(shareUrl)}',
    );
    await _launchAppOrWeb(appUri, webUri);
  }

  Future<void> _shareOnGmail(String title, String shareUrl) async {
    final subject = Uri.encodeComponent(title);
    final body = Uri.encodeComponent(shareUrl);
    final appUri = Uri.parse(
      'intent://compose?subject=$subject&body=$body#Intent;scheme=mailto;package=com.google.android.gm;end',
    );
    final secondaryMailAppUri = Uri.parse(
      'mailto:?subject=$subject&body=$body',
    );
    final webUri = Uri.parse(
      'https://mail.google.com/mail/?view=cm&fs=1&su=$subject&body=$body',
    );

    try {
      if (await canLaunchUrl(appUri)) {
        final opened = await launchUrl(
          appUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        if (opened) {
          return;
        }
      }
    } catch (_) {}

    try {
      if (await canLaunchUrl(secondaryMailAppUri)) {
        final opened = await launchUrl(
          secondaryMailAppUri,
          mode: LaunchMode.externalApplication,
        );
        if (opened) {
          return;
        }
      }
    } catch (_) {}

    await _launchAppOrWeb(appUri, webUri);
  }

  Future<void> _copyLink(String shareUrl) async {
    await Clipboard.setData(ClipboardData(text: shareUrl));
    Get.snackbar('Copied', 'Link copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.profileButtonColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 156,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.54, 1.00),
                  end: Alignment(0.54, -0.00),
                  colors: [const Color(0xFF00CABE), const Color(0xFF006EF0)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(
                      () => Text(
                        detailsController.title.isEmpty
                            ? 'Blog Details'
                            : detailsController.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(() {
                if (detailsController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (detailsController.errorMessage.value != null) {
                  return Center(
                    child: Text(
                      'Error: ${detailsController.errorMessage.value}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final shareUrl =
                    'https://jupitermarinesales.com/blogs/${detailsController.details.value?.id ?? ''}';
                final shareTitle = detailsController.title.isEmpty
                    ? 'Check this blog'
                    : detailsController.title;
                final shareMessage = '$shareTitle\n$shareUrl';

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    detailsController.imageUrl.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 159,
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image: NetworkImage(detailsController.imageUrl),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.24),
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 159,
                            decoration: ShapeDecoration(
                              color: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.24),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 9.47,
                      children: [
                        Text(
                          detailsController.readTimeText,
                          style: TextStyle(
                            color: const Color(0xFF6C6F6F) /* grey-400 */,
                            fontSize: 9.47,
                            fontFamily: 'Inter Tight',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                        Text(
                          detailsController.dateText,
                          style: TextStyle(
                            color: const Color(0xFF6C6F6F) /* grey-400 */,
                            fontSize: 9.47,
                            fontFamily: 'Inter Tight',
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      detailsController.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.02,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
                        letterSpacing: 1.18,
                      ),
                    ),
                    Html(data: detailsController.description),
                    // Container(
                    //   width: double.infinity,
                    //   height: 219,
                    //   decoration: ShapeDecoration(
                    //     image: DecorationImage(
                    //       image: detailsController.imageUrl.isNotEmpty
                    //           ? NetworkImage(detailsController.imageUrl)
                    //           : AssetImage(Imagepath.blogDetails2)
                    //                 as ImageProvider,
                    //       fit: BoxFit.cover,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(7.10),
                    //     ),
                    //   ),
                    // ),
                    Text(
                      'Share With',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.02,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.18,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //spacing: 17.75,
                      children: [
                        Container(
                          //height: 37.86,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF5FEFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9.47),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 1,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 4,
                            children: [
                              Text(
                                _truncateText(shareUrl, 30),
                                style: TextStyle(
                                  color: const Color(0xFF4A4D4D) /* grey-500 */,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await _copyLink(shareUrl);
                                },
                                child: Icon(
                                  Icons.copy,
                                  // size: 14.20,
                                  color: const Color(0xFF4A4D4D) /* grey-500 */,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _shareOnWhatsApp(shareMessage);
                          },
                          child: Container(
                            width: 26.56,
                            height: 26.56,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF65D072),
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.whatsapp,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _shareOnFacebook(shareUrl);
                          },
                          child: Container(
                            width: 26.56,
                            height: 26.56,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF425893),
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.facebookF,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _shareOnTwitter(shareTitle, shareUrl);
                          },
                          child: Container(
                            width: 26.56,
                            height: 26.56,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF4D9FEB),
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.twitter,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _shareOnGmail(shareTitle, shareUrl);
                          },
                          child: Container(
                            width: 26.56,
                            height: 26.56,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF888888),
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.solidEnvelope,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Read More Related Blogs',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 283,
                      child: Obx(
                        () => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.posts.length,
                          itemBuilder: (context, index) {
                            final post = controller.posts[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: SizedBox(
                                width: 223,
                                child: BlogCard(
                                  post: post,
                                  onTap: () {
                                    Get.off(
                                      () => BlogDetailsScreen(),
                                      arguments: {'id': post.id},
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    DiscoverMoreSection(),
                    SizedBox(height: 30),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
