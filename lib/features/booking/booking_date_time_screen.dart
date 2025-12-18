import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/models/professional.dart';
import 'models/booking_request.dart';
import 'booking_confirmation_screen.dart';

class BookingDateTimeScreen extends StatefulWidget {
  final Professional professional;

  const BookingDateTimeScreen({
    super.key,
    required this.professional,
  });

  @override
  State<BookingDateTimeScreen> createState() => _BookingDateTimeScreenState();
}

class _BookingDateTimeScreenState extends State<BookingDateTimeScreen> {
  DateTime? _selectedDate;
  String? _selectedTime;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> _availableTimes = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
  ];

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.professional.phone;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  DateTime _getFirstAvailableDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _canContinue() {
    return _selectedDate != null &&
        _selectedTime != null &&
        _addressController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty;
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? _getFirstAvailableDate(),
      firstDate: _getFirstAvailableDate(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      locale: const Locale('fr', 'FR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        if (_selectedTime != null) {
          final selectedDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            int.parse(_selectedTime!.split(':')[0]),
            int.parse(_selectedTime!.split(':')[1]),
          );
          // Réinitialiser l'heure si la date sélectionnée est aujourd'hui et l'heure est passée
          if (selectedDateTime.isBefore(DateTime.now())) {
            _selectedTime = null;
          }
        }
      });
    }
  }

  void _continueToConfirmation() {
    if (!_canContinue()) return;

    final bookingRequest = BookingRequest(
      professionalId: widget.professional.id,
      professionalName: widget.professional.name,
      professionalImage: widget.professional.image,
      serviceName: widget.professional.service,
      selectedDate: _selectedDate!,
      selectedTime: _selectedTime!,
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      price: widget.professional.price,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          bookingRequest: bookingRequest,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.booking),
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
                          widget.professional.image,
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
                            widget.professional.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.professional.service,
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
            // Sélection de la date
            Text(
              AppStrings.selectDate,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: _selectedDate != null
                        ? AppColors.primary
                        : AppColors.grey.withOpacity(0.3),
                    width: _selectedDate != null ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? DateFormat('EEEE d MMMM yyyy', 'fr_FR')
                              .format(_selectedDate!)
                          : 'Choisir une date',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: _selectedDate != null
                            ? AppColors.textPrimary
                            : AppColors.textLight,
                        fontWeight: _selectedDate != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: _selectedDate != null
                          ? AppColors.primary
                          : AppColors.textLight,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Sélection de l'heure
            Text(
              AppStrings.selectTime,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            if (_selectedDate == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Veuillez d\'abord sélectionner une date',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.2,
                ),
                itemCount: _availableTimes.length,
                itemBuilder: (context, index) {
                  final time = _availableTimes[index];
                  final isSelected = _selectedTime == time;
                  final timeParts = time.split(':');
                  final timeDateTime = DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    int.parse(timeParts[0]),
                    int.parse(timeParts[1]),
                  );
                  final isPast = timeDateTime.isBefore(DateTime.now());

                  return InkWell(
                    onTap: isPast
                        ? null
                        : () {
                            setState(() {
                              _selectedTime = isSelected ? null : time;
                            });
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : isPast
                                ? AppColors.lightGrey
                                : AppColors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey.withOpacity(0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppColors.white
                                : isPast
                                    ? AppColors.textLight
                                    : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 24),
            // Adresse
            Text(
              AppStrings.bookingAddress,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: 'Votre adresse complète',
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            // Téléphone
            Text(
              AppStrings.phone,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                hintText: '+212 6XX XXX XXX',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            // Notes
            Text(
              AppStrings.bookingNotes,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: AppStrings.bookingNotesHint,
                prefixIcon: const Icon(Icons.note),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
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
          child: ElevatedButton(
            onPressed: _canContinue() ? _continueToConfirmation : null,
            child: Text(AppStrings.next),
          ),
        ),
      ),
    );
  }
}

