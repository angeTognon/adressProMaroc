import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/locale/locale_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language, color: AppColors.white),
      onSelected: (value) {
        switch (value) {
          case 'fr':
            localeProvider.setFrench();
            break;
          case 'darija':
            localeProvider.setDarija();
            break;
          case 'ar':
            localeProvider.setArabic();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'fr',
          child: Row(
            children: [
              if (currentLocale.languageCode == 'fr' && currentLocale.countryCode == 'FR')
                const Icon(Icons.check, color: AppColors.primary, size: 20)
              else
                const SizedBox(width: 20),
              const SizedBox(width: 8),
              const Text('🇫🇷 Français'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'darija',
          child: Row(
            children: [
              if (currentLocale.languageCode == 'fr' && currentLocale.countryCode == 'MA')
                const Icon(Icons.check, color: AppColors.primary, size: 20)
              else
                const SizedBox(width: 20),
              const SizedBox(width: 8),
              const Text('🇲🇦 Darija'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'ar',
          child: Row(
            children: [
              if (currentLocale.languageCode == 'ar')
                const Icon(Icons.check, color: AppColors.primary, size: 20)
              else
                const SizedBox(width: 20),
              const SizedBox(width: 8),
              const Text('🇸🇦 العربية'),
            ],
          ),
        ),
      ],
    );
  }
}

