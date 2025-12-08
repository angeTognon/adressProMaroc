import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/booking.dart';
import '../../core/services/booking_service.dart';
import '../../core/utils/preferences_helper.dart';
import 'booking_list_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool _isLoading = true;
  List<Booking> _bookings = [];

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await PreferencesHelper.getUserId() ?? 'guest_user';
      final bookings = await BookingService.getBookings(userId);

      if (mounted) {
        setState(() {
          _bookings = bookings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.myBookings),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return BookingListScreen(bookings: _bookings);
  }
}

