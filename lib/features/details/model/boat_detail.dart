class BoatDetail {
  final String id;
  final String listingId;
  final String userId;
  final String name;
  final double price;
  final String description;
  final double? length;
  final String? cLass;
  final double? beam;
  final double? draft;
  final String? condition;
  final int? buildYear;
  final String? make;
  final String? model;
  final String? material;
  final String? city;
  final String? state;
  final List<ImageItem> coverImages;
  final List<ImageItem> galleryImages;
  final List<ExtraDetail> extraDetails;
  final int? enginesNumber;
  final int? cabinsNumber;
  final int? headsNumber;

  BoatDetail({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.name,
    required this.cLass,
    required this.condition,
    required this.material,
    required this.price,

    required this.description,
    this.length,
    this.beam,
    this.draft,
    this.buildYear,
    this.make,
    this.model,
    this.city,
    this.state,
    required this.coverImages,
    required this.galleryImages,
    required this.extraDetails,
    this.enginesNumber,
    this.cabinsNumber,
    this.headsNumber,
  });

  factory BoatDetail.fromJson(Map<String, dynamic> json) {
    List<ImageItem> _parseImages(dynamic input) {
      final list = <ImageItem>[];
      if (input is List) {
        for (final item in input) {
          try {
            list.add(ImageItem.fromJson(item));
          } catch (_) {}
        }
      }
      return list;
    }

    List<ExtraDetail> _parseExtra(dynamic input) {
      final list = <ExtraDetail>[];
      if (input is List) {
        for (final item in input) {
          try {
            list.add(ExtraDetail.fromJson(item));
          } catch (_) {}
        }
      }
      return list;
    }

    return BoatDetail(
      id: json['id'] ?? '',
      listingId: json['listingId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      material: json['material'] ?? '',
      cLass: json['class'] ?? '',
      condition: json['condition'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] ?? '',
      length: (json['length'] is num)
          ? (json['length'] as num).toDouble()
          : null,
      beam: (json['beam'] is num) ? (json['beam'] as num).toDouble() : null,
      draft: (json['draft'] is num) ? (json['draft'] as num).toDouble() : null,
      buildYear: json['buildYear'] is int ? json['buildYear'] as int : null,
      make: json['make'],
      model: json['model'],
      city: json['city'],
      state: json['state'],
      coverImages: _parseImages(json['coverImages']),
      galleryImages: _parseImages(json['galleryImages']),
      extraDetails: _parseExtra(json['extraDetails']),
      enginesNumber: json['enginesNumber'] is int
          ? json['enginesNumber'] as int
          : null,
      cabinsNumber: json['cabinsNumber'] is int
          ? json['cabinsNumber'] as int
          : null,
      headsNumber: json['headsNumber'] is int
          ? json['headsNumber'] as int
          : null,
    );
  }
}

class ImageItem {
  final String id;
  final String fileId;
  final String url;
  final String mimeType;
  final String imageType;

  ImageItem({
    required this.id,
    required this.fileId,
    required this.url,
    required this.mimeType,
    required this.imageType,
  });

  factory ImageItem.fromJson(Map<String, dynamic> json) {
    return ImageItem(
      id: json['id'] ?? '',
      fileId: json['fileId'] ?? '',
      url: json['url'] ?? '',
      mimeType: json['mimeType'] ?? '',
      imageType: json['imageType'] ?? '',
    );
  }
}

class ExtraDetail {
  final String title;
  final String description;

  ExtraDetail({required this.title, required this.description});

  factory ExtraDetail.fromJson(Map<String, dynamic> json) {
    return ExtraDetail(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
