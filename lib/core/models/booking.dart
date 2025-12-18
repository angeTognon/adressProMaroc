enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Booking {
  final String id;
  final String professionalId;
  final String professionalName;
  final String professionalImage;
  final String serviceName;
  final String userId;
  final DateTime dateTime;
  final String address;
  final String phone;
  final String? notes;
  final double price;
  final BookingStatus status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.professionalId,
    required this.professionalName,
    required this.professionalImage,
    required this.serviceName,
    required this.userId,
    required this.dateTime,
    required this.address,
    required this.phone,
    this.notes,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  String get statusText {
    switch (status) {
      case BookingStatus.pending:
        return 'En attente';
      case BookingStatus.confirmed:
        return 'Confirmé';
      case BookingStatus.inProgress:
        return 'En cours';
      case BookingStatus.completed:
        return 'Terminé';
      case BookingStatus.cancelled:
        return 'Annulé';
    }
  }

  String get statusIcon {
    switch (status) {
      case BookingStatus.pending:
        return '⏳';
      case BookingStatus.confirmed:
        return '✅';
      case BookingStatus.inProgress:
        return '🔧';
      case BookingStatus.completed:
        return '✔️';
      case BookingStatus.cancelled:
        return '❌';
    }
  }
}

