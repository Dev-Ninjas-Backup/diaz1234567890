class WorkingHour {
  final String day;
  final String hours;

  WorkingHour({required this.day, required this.hours});
}

class ContactInfoData {
  final String address;
  final String email;
  final String phone;
  final List<WorkingHour> workingHours;
  final Map<String, String> socialMedia;

  ContactInfoData({
    required this.address,
    required this.email,
    required this.phone,
    required this.workingHours,
    required this.socialMedia,
  });
}
