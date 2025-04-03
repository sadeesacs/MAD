class BookingFormData {
  String? serviceId;
  String? date;
  String? fromTime;
  String? toTime;
  String? district;
  String? address;
  double? latitude;
  double? longitude;
  String? additionalNotes;
  final String serviceTitle;
  final String providerName;
  final double pricePerHour;
  final String category;
  final String imageUrl;

  BookingFormData({
    this.serviceId,
    required this.serviceTitle,
    required this.providerName,
    required this.pricePerHour,
    required this.category,
    required this.imageUrl,
  });
}
