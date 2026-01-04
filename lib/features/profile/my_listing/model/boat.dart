class Boat {
  final String id;
  final String listingId;
  final String userId;
  final String name;
  final double price;
  final String description;
  final int? buildYear;
  final String? make;
  final String? model;
  final String? fuelType;
  final double? length;
  final String? city;
  final String? state;
  final String? status;
  final List<ImageItem> coverImages;

  Boat({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.name,
    required this.price,
    required this.description,
    this.buildYear,
    this.make,
    this.model,
    this.fuelType,
    this.length,
    this.city,
    this.state,
    this.status,
    required this.coverImages,
  });

  factory Boat.fromJson(Map<String, dynamic> json) {
    final coverImages = <ImageItem>[];
    if (json['coverImages'] is List) {
      for (final item in json['coverImages']) {
        try {
          coverImages.add(ImageItem.fromJson(item));
        } catch (_) {}
      }
    }

    return Boat(
      id: json['id'] ?? '',
      listingId: json['listingId'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      description: json['description'] ?? '',
      buildYear: json['buildYear'] is int ? json['buildYear'] as int : null,
      make: json['make'],
      model: json['model'],
      fuelType: json['fuelType'],
      length: (json['length'] is num)
          ? (json['length'] as num).toDouble()
          : null,
      city: json['city'],
      state: json['state'],
      status: json['status'],
      coverImages: coverImages,
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
