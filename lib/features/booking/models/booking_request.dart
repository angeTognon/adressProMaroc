class BookingRequest {
  final String professionalId;
  final String professionalName;
  final String professionalImage;
  final String serviceName;
  final DateTime selectedDate;
  final String selectedTime;
  final String address;
  final String phone;
  final String? notes;
  final double price;

  BookingRequest({
    required this.professionalId,
    required this.professionalName,
    required this.professionalImage,
    required this.serviceName,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.phone,
    this.notes,
    required this.price,
  });

  DateTime get dateTime {
    final timeParts = selectedTime.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );
  }
}

