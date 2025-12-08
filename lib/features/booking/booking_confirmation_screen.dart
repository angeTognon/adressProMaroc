import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/booking.dart';
import '../../core/services/booking_service.dart';
import '../../core/utils/preferences_helper.dart';
import 'models/booking_request.dart';
import 'booking_success_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final BookingRequest bookingRequest;

  const BookingConfirmationScreen({
    super.key,
    required this.bookingRequest,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  bool _isLoading = false;

  Future<void> _confirmBooking(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await PreferencesHelper.getUserId() ?? 'guest_user';
      
      final booking = Booking(
        id: 'booking_${DateTime.now().millisecondsSinceEpoch}',
        professionalId: widget.bookingRequest.professionalId,
        professionalName: widget.bookingRequest.professionalName,
        professionalImage: widget.bookingRequest.professionalImage,
        serviceName: widget.bookingRequest.serviceName,
        userId: userId,
        dateTime: widget.bookingRequest.dateTime,
        address: widget.bookingRequest.address,
        phone: widget.bookingRequest.phone,
        notes: widget.bookingRequest.notes,
        price: widget.bookingRequest.price,
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      );

      await BookingService.createBooking(booking);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: booking),
        ),
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la réservation: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.bookingSummary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informations du professionnel
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          widget.bookingRequest.professionalImage,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bookingRequest.professionalName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.bookingRequest.serviceName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.bookingSummary,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // Date et heure
            _buildInfoRow(
              context,
              Icons.calendar_today,
              AppStrings.bookingDate,
              DateFormat('EEEE d MMMM yyyy à HH:mm', 'fr_FR')
                  .format(widget.bookingRequest.dateTime),
            ),
            const SizedBox(height: 16),
            // Adresse
            _buildInfoRow(
              context,
              Icons.location_on,
              AppStrings.bookingAddress,
              widget.bookingRequest.address,
            ),
            const SizedBox(height: 16),
            // Téléphone
            _buildInfoRow(
              context,
              Icons.phone,
              AppStrings.phone,
              widget.bookingRequest.phone,
            ),
            if (widget.bookingRequest.notes != null && widget.bookingRequest.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                context,
                Icons.note,
                AppStrings.bookingNotes,
                widget.bookingRequest.notes!,
              ),
            ],
            const SizedBox(height: 24),
            // Prix
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.totalAmount,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${widget.bookingRequest.price.toStringAsFixed(0)} MAD',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: _isLoading ? null : () => _confirmBooking(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      )
                    : Text(AppStrings.confirmBooking),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

