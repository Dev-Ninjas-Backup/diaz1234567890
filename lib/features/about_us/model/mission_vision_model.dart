class MissionVision {
  final String id;
  final String site;
  final String title;
  final String missionTitle;
  final String description;
  final String visionTitle;
  final String visionDescription;
  final String image1Id;
  final String image2Id;
  final String image3Id;
  final MissionVisionImage? image1;
  final MissionVisionImage? image2;
  final MissionVisionImage? image3;

  MissionVision({
    required this.id,
    required this.site,
    required this.title,
    required this.missionTitle,
    required this.description,
    required this.visionTitle,
    required this.visionDescription,
    required this.image1Id,
    required this.image2Id,
    required this.image3Id,
    this.image1,
    this.image2,
    this.image3,
  });

  factory MissionVision.fromJson(Map<String, dynamic> json) {
    return MissionVision(
      id: json['id']?.toString() ?? '',
      site: json['site']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      missionTitle: json['missionTitle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      visionTitle: json['visionTitle']?.toString() ?? '',
      visionDescription: json['visionDescription']?.toString() ?? '',
      image1Id: json['image1Id']?.toString() ?? '',
      image2Id: json['image2Id']?.toString() ?? '',
      image3Id: json['image3Id']?.toString() ?? '',
      image1: json['image1'] != null
          ? MissionVisionImage.fromJson(json['image1'])
          : null,
      image2: json['image2'] != null
          ? MissionVisionImage.fromJson(json['image2'])
          : null,
      image3: json['image3'] != null
          ? MissionVisionImage.fromJson(json['image3'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'site': site,
      'title': title,
      'missionTitle': missionTitle,
      'description': description,
      'visionTitle': visionTitle,
      'visionDescription': visionDescription,
      'image1Id': image1Id,
      'image2Id': image2Id,
      'image3Id': image3Id,
      'image1': image1?.toJson(),
      'image2': image2?.toJson(),
      'image3': image3?.toJson(),
    };
  }
}

class MissionVisionImage {
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

  MissionVisionImage({
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

  factory MissionVisionImage.fromJson(Map<String, dynamic> json) {
    return MissionVisionImage(
      id: json['id']?.toString() ?? '',
      filename: json['filename']?.toString() ?? '',
      originalFilename: json['originalFilename']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      fileType: json['fileType']?.toString() ?? '',
      mimeType: json['mimeType']?.toString() ?? '',
      size: json['size'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
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
