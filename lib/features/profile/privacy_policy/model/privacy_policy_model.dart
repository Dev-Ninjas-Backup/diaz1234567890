class PrivacyPolicyModel {
  final String id;
  final String site;
  final String privacyTitle;
  final String privacyDescription;

  PrivacyPolicyModel({
    required this.id,
    required this.site,
    required this.privacyTitle,
    required this.privacyDescription,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyModel(
      id: json['id'] ?? '',
      site: json['site'] ?? '',
      privacyTitle: json['privacyTitle'] ?? '',
      privacyDescription: json['privacyDescription'] ?? '',
    );
  }
}