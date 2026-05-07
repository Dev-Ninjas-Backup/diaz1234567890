class Blog {
  final String id;
  final String blogTitle;
  final String blogDescription;
  final int readTime;
  final String postStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final BlogImage? blogImage;
  final int pageViewCount;

  Blog({
    required this.id,
    required this.blogTitle,
    required this.blogDescription,
    required this.readTime,
    required this.postStatus,
    required this.createdAt,
    required this.updatedAt,
    this.blogImage,
    required this.pageViewCount,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? '',
      blogTitle: json['blogTitle'] ?? '',
      blogDescription: json['blogDescription'] ?? '',
      readTime: json['readTime'] ?? 0,
      postStatus: json['postStatus'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      blogImage: json['blogImage'] != null
          ? BlogImage.fromJson(json['blogImage'])
          : null,
      pageViewCount: json['pageViewCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blogTitle': blogTitle,
      'blogDescription': blogDescription,
      'readTime': readTime,
      'postStatus': postStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'blogImage': blogImage?.toJson(),
      'pageViewCount': pageViewCount,
    };
  }
}

class BlogImage {
  final String id;
  final String filename;
  final String originalFilename;
  final String path;
  final String url;
  final String fileType;
  final String mimeType;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogImage({
    required this.id,
    required this.filename,
    required this.originalFilename,
    required this.path,
    required this.url,
    required this.fileType,
    required this.mimeType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BlogImage.fromJson(Map<String, dynamic> json) {
    return BlogImage(
      id: json['id'] ?? '',
      filename: json['filename'] ?? '',
      originalFilename: json['originalFilename'] ?? '',
      path: json['path'] ?? '',
      url: json['url'] ?? '',
      fileType: json['fileType'] ?? '',
      mimeType: json['mimeType'] ?? '',
      size: json['size'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'originalFilename': originalFilename,
      'path': path,
      'url': url,
      'fileType': fileType,
      'mimeType': mimeType,
      'size': size,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
