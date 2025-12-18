import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/booking.dart';

class BookingService {
  static const String _keyBookings = 'user_bookings';

  // Récupérer toutes les réservations
  static Future<List<Booking>> getBookings(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getString('${_keyBookings}_$userId');

    if (bookingsJson == null) {
      return [];
    }

    final List<dynamic> bookingsList = json.decode(bookingsJson);
    return bookingsList.map((json) => _bookingFromJson(json)).toList();
  }

  // Créer une nouvelle réservation
  static Future<Booking> createBooking(Booking booking) async {
    final bookings = await getBookings(booking.userId);
    bookings.add(booking);

    await _saveBookings(booking.userId, bookings);
    return booking;
  }

  // Annuler une réservation
  static Future<bool> cancelBooking(String bookingId, String userId) async {
    final bookings = await getBookings(userId);
    final index = bookings.indexWhere((b) => b.id == bookingId);

    if (index == -1) {
      return false;
    }

    final updatedBooking = Booking(
      id: bookings[index].id,
      professionalId: bookings[index].professionalId,
      professionalName: bookings[index].professionalName,
      professionalImage: bookings[index].professionalImage,
      serviceName: bookings[index].serviceName,
      userId: bookings[index].userId,
      dateTime: bookings[index].dateTime,
      address: bookings[index].address,
      phone: bookings[index].phone,
      notes: bookings[index].notes,
      price: bookings[index].price,
      status: BookingStatus.cancelled,
      createdAt: bookings[index].createdAt,
    );

    bookings[index] = updatedBooking;
    await _saveBookings(userId, bookings);
    return true;
  }

  // Sauvegarder les réservations
  static Future<void> _saveBookings(String userId, List<Booking> bookings) async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = json.encode(
      bookings.map((booking) => _bookingToJson(booking)).toList(),
    );
    await prefs.setString('${_keyBookings}_$userId', bookingsJson);
  }

  // Conversion JSON
  static Map<String, dynamic> _bookingToJson(Booking booking) {
    return {
      'id': booking.id,
      'professionalId': booking.professionalId,
      'professionalName': booking.professionalName,
      'professionalImage': booking.professionalImage,
      'serviceName': booking.serviceName,
      'userId': booking.userId,
      'dateTime': booking.dateTime.toIso8601String(),
      'address': booking.address,
      'phone': booking.phone,
      'notes': booking.notes,
      'price': booking.price,
      'status': booking.status.index,
      'createdAt': booking.createdAt.toIso8601String(),
    };
  }

  static Booking _bookingFromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      professionalId: json['professionalId'],
      professionalName: json['professionalName'],
      professionalImage: json['professionalImage'],
      serviceName: json['serviceName'],
      userId: json['userId'],
      dateTime: DateTime.parse(json['dateTime']),
      address: json['address'],
      phone: json['phone'],
      notes: json['notes'],
      price: (json['price'] as num).toDouble(),
      status: BookingStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

