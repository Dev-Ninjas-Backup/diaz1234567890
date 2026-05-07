// ignore_for_file: deprecated_member_use

import 'package:diaz1234567890/features/blog/controller/blog_controller.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final BlogPost post;
  final VoidCallback? onTap;

  const BlogCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: post.imageUrl.isNotEmpty
                    ? Image.network(
                        post.imageUrl,
                        height: 112,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 112,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      )
                    : Image.asset(
                        post.imagePath,
                        height: 112,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),

              /// CONTENT
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          post.readTime,
                          style: const TextStyle(
                            color: Color(0xFF6C6F6F),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          post.date,
                          style: const TextStyle(
                            color: Color(0xFF6C6F6F),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // const SizedBox(height: 8),
                    // SizedBox(height: 40, child: Html(data: post.excerpt)),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Read More',
                        style: TextStyle(
                          color: Color(0xFF00A2AB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
