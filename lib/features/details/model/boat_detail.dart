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
  final String? zip;
  final String? fuelType;
  final String? engineType;
  final String? propType;
  final String? propMaterial;
  final String? status;
  final String? videoURL;
  final BoatDimensions? boatDimensions;
  final List<EngineItem> engines;
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
    this.zip,
    this.fuelType,
    this.engineType,
    this.propType,
    this.propMaterial,
    this.status,
    this.videoURL,
    this.boatDimensions,
    required this.engines,
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
      engines: (json['engines'] is List)
          ? (json['engines'] as List)
                .map((e) => EngineItem.fromJson(e as Map<String, dynamic>))
                .toList()
          : <EngineItem>[],
      boatDimensions: json['boatDimensions'] is Map
          ? BoatDimensions.fromJson(
              json['boatDimensions'] as Map<String, dynamic>,
            )
          : null,
      fuelType: json['fuelType'] ?? json['fuel_type'] ?? '',
      engineType: json['engineType'] ?? '',
      propType: json['propType'] ?? json['propellerType'] ?? '',
      propMaterial: json['propMaterial'] ?? json['propellerMaterial'] ?? '',
      zip: json['zip'] ?? '',
      status: json['status'] ?? '',
      videoURL: json['videoURL'] ?? '',
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
    // Support both { "title": ..., "description": ... }
    // and older/alternate { "key": ..., "value": ... } shapes.
    final title = json['title'] ?? json['key'] ?? '';
    final description = json['description'] ?? json['value'] ?? '';
    return ExtraDetail(title: title, description: description);
  }
}

class EngineItem {
  final String id;
  final int? hours;
  final int? horsepower;
  final String? make;
  final String? model;
  final String? fuelType;
  final String? propellerType;

  EngineItem({
    required this.id,
    this.hours,
    this.horsepower,
    this.make,
    this.model,
    this.fuelType,
    this.propellerType,
  });

  factory EngineItem.fromJson(Map<String, dynamic> json) {
    return EngineItem(
      id: json['id'] ?? '',
      hours: json['hours'] is int ? json['hours'] as int : null,
      horsepower: json['horsepower'] is num
          ? (json['horsepower'] as num).toInt()
          : null,
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      fuelType: json['fuelType'] ?? '',
      propellerType: json['propellerType'] ?? json['propeller'] ?? '',
    );
  }
}

class BoatDimensions {
  final int? lengthFeet;
  final int? lengthInches;
  final int? beamFeet;
  final int? beamInches;
  final int? draftFeet;
  final int? draftInches;

  BoatDimensions({
    this.lengthFeet,
    this.lengthInches,
    this.beamFeet,
    this.beamInches,
    this.draftFeet,
    this.draftInches,
  });

  factory BoatDimensions.fromJson(Map<String, dynamic> json) {
    int? _toInt(dynamic v) => v is int ? v as int : null;
    return BoatDimensions(
      lengthFeet: _toInt(json['lengthFeet']),
      lengthInches: _toInt(json['lengthInches']),
      beamFeet: _toInt(json['beamFeet']),
      beamInches: _toInt(json['beamInches']),
      draftFeet: _toInt(json['draftFeet']),
      draftInches: _toInt(json['draftInches']),
    );
  }
}
