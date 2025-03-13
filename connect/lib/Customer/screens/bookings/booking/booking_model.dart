// lib/Customer/screens/bookings/booking/booking_model.dart
class BookingModel {
  DateTime? date;
  DateTime? fromTime;
  DateTime? toTime;
  String? district;
  String? address;
  double? lat;
  double? lng;
  String? notes;

  // Helper getters, e.g. total hours
  double get totalHours {
    if (fromTime == null || toTime == null) return 0;
    final diff = toTime!.difference(fromTime!).inMinutes / 60.0;
    return diff < 0 ? 0 : diff;
  }
}
