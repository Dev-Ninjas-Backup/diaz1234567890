class BlogDetails {
  final String id;
  final String blogImageId;
  final String blogTitle;
  final String blogDescription;
  final int readTime;
  final DateTime? createdAt;
  final BlogDetailsImage? blogImage;

  BlogDetails({
    required this.id,
    required this.blogImageId,
    required this.blogTitle,
    required this.blogDescription,
    required this.readTime,
    required this.createdAt,
    this.blogImage,
  });

  factory BlogDetails.fromJson(Map<String, dynamic> json) {
    final dynamic imageJson = json['blogImage'];

    return BlogDetails(
      id: json['id']?.toString() ?? '',
      blogImageId:
          json['blogImageId']?.toString() ??
          (imageJson is Map<String, dynamic>
              ? imageJson['id']?.toString() ?? ''
              : ''),
      blogTitle: json['blogTitle']?.toString() ?? '',
      blogDescription: json['blogDescription']?.toString() ?? '',
      readTime: json['readTime'] is int
          ? json['readTime'] as int
          : int.tryParse(json['readTime']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      blogImage: imageJson is Map<String, dynamic>
          ? BlogDetailsImage.fromJson(imageJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blogImageId': blogImageId,
      'blogTitle': blogTitle,
      'blogDescription': blogDescription,
      'readTime': readTime,
      'createdAt': createdAt?.toIso8601String(),
      'blogImage': blogImage?.toJson(),
    };
  }
}

class BlogDetailsImage {
  final String id;
  final String url;

  BlogDetailsImage({required this.id, required this.url});

  factory BlogDetailsImage.fromJson(Map<String, dynamic> json) {
    return BlogDetailsImage(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url};
  }
}
