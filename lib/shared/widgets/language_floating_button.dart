import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/locale/locale_provider.dart';

class LanguageFloatingButton extends StatelessWidget {
  const LanguageFloatingButton({super.key});

  void _showLanguageDialog(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Choisir la langue',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption(
              context,
              localeProvider,
              'fr',
              'FR',
              '🇫🇷',
              'Français',
              currentLocale.languageCode == 'fr' && currentLocale.countryCode == 'FR',
            ),
            _buildLanguageOption(
              context,
              localeProvider,
              'fr',
              'MA',
              '🇲🇦',
              'Darija',
              currentLocale.languageCode == 'fr' && currentLocale.countryCode == 'MA',
            ),
            _buildLanguageOption(
              context,
              localeProvider,
              'ar',
              'MA',
              '🇸🇦',
              'العربية',
              currentLocale.languageCode == 'ar',
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LocaleProvider localeProvider,
    String languageCode,
    String countryCode,
    String flag,
    String label,
    bool isSelected,
  ) {
    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 32),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        localeProvider.setLocale(Locale(languageCode, countryCode));
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showLanguageDialog(context),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.language, color: AppColors.white),
    );
  }
}

