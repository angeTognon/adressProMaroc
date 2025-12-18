import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:showcaseview/showcaseview.dart';
import 'core/locale/locale_provider.dart';
import 'core/locale/app_localizations.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'fr_FR';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return ShowCaseWidget(
            builder: (context) => MaterialApp(
              title: 'Khadma',
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              locale: localeProvider.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('fr', 'FR'), // Français
                Locale('fr', 'MA'), // Darija
                Locale('ar', 'MA'), // Arabe
                Locale('en', 'US'), // Anglais (fallback)
              ],
            ),
          );
        },
      ),
    );
  }
}
