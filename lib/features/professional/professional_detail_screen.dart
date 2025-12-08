import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../core/models/professional.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/locale/app_localizations.dart';
import '../../core/utils/preferences_helper.dart';
import '../booking/booking_date_time_screen.dart';
import '../auth/login_screen.dart';

class ProfessionalDetailScreen extends StatefulWidget {
  final Professional professional;

  const ProfessionalDetailScreen({
    super.key,
    required this.professional,
  });

  @override
  State<ProfessionalDetailScreen> createState() => _ProfessionalDetailScreenState();
}

class _ProfessionalDetailScreenState extends State<ProfessionalDetailScreen> {
  final GlobalKey _bookButtonKey = GlobalKey();
  bool _showcaseShown = false;

  @override
  void initState() {
    super.initState();
    _checkAndShowShowcase();
  }

  Future<void> _checkAndShowShowcase() async {
    final isCompleted = await PreferencesHelper.isBookButtonTutorialCompleted();
    if (!isCompleted && mounted && !_showcaseShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_showcaseShown) {
          _showcaseShown = true;
          ShowCaseWidget.of(context).startShowCase([_bookButtonKey]);
        }
      });
    }
  }

  Professional get professional => widget.professional;

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final localizations = AppLocalizations.of(context);
    try {
      // En production, utiliser url_launcher
      // final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      // if (await canLaunchUrl(phoneUri)) {
      //   await launchUrl(phoneUri);
      // }
      // Pour l'instant, copier le numéro dans le presse-papier
      await Clipboard.setData(ClipboardData(text: phoneNumber));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations?.translate('phone_copied') ?? 'Numéro copié'}: $phoneNumber')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations?.translate('error') ?? 'Erreur')),
      );
    }
  }

  Future<void> _sendMessage(BuildContext context, String phoneNumber) async {
    final localizations = AppLocalizations.of(context);
    try {
      // En production, utiliser url_launcher pour SMS
      await Clipboard.setData(ClipboardData(text: phoneNumber));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations?.translate('phone_copied') ?? 'Numéro copié'}: $phoneNumber')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations?.translate('error_sending_message') ?? 'Erreur lors de l\'envoi du message')),
      );
    }
  }

  Future<void> _navigateToBooking(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    // Vérifier si l'utilisateur est connecté
    final isLoggedIn = await PreferencesHelper.isLoggedIn();
    
    if (!isLoggedIn) {
      // Afficher une boîte de dialogue élégante
      if (!context.mounted) return;
      
      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  localizations?.translate('login_required') ?? 'Connexion requise',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                localizations?.translate('must_login_to_book') ?? 'Vous devez être connecté pour réserver un service.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.accent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        localizations?.translate('create_account_or_login') ?? 'Créer un compte ou se connecter',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.accent.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        localizations?.translate('create_account_or_login') ?? 'Créez un compte ou connectez-vous pour continuer',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                localizations?.translate('cancel') ?? 'Annuler',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                localizations?.translate('login') ?? 'Se connecter',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // Si connecté, naviguer vers la réservation
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingDateTimeScreen(professional: professional),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primary,
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    professional.image,
                    style: const TextStyle(fontSize: 100),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              professional.name,
                              style:
                                  Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              professional.service,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppColors.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              professional.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${professional.reviewsCount} ${localizations?.translate('reviews') ?? AppStrings.reviews}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          Icons.location_on,
                          localizations?.translate('location') ?? AppStrings.location,
                          professional.location,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          Icons.attach_money,
                          localizations?.translate('price') ?? AppStrings.price,
                          '${professional.price} ${localizations?.translate('currency') ?? 'MAD'}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    context,
                    Icons.access_time,
                    localizations?.translate('availability') ?? AppStrings.availability,
                    professional.isAvailable 
                      ? (localizations?.translate('available') ?? 'Disponible') 
                      : (localizations?.translate('not_available') ?? 'Non disponible'),
                  ),
                  const SizedBox(height: 24),
                  // Afficher la section "À propos" uniquement si la description n'est pas vide (et non null)
                  if (professional.description.isNotEmpty && professional.description.trim().isNotEmpty) ...[
                    Text(
                      localizations?.translate('about') ?? AppStrings.about,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      professional.description.trim(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text(
                    localizations?.translate('services') ?? AppStrings.services,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: professional.services.map((service) {
                      return Chip(
                        label: Text(service),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: TextStyle(color: AppColors.primary),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _makePhoneCall(context, professional.phone),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          localizations?.translate('call') ?? AppStrings.call,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _sendMessage(context, professional.phone),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.message, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          localizations?.translate('message') ?? AppStrings.message,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                  child: Showcase(
                  key: _bookButtonKey,
                  title: localizations?.translate('book_easily') ?? 'Réservez facilement',
                  description: localizations?.translate('book_easily_description') ?? 'Vous n\'arrivez pas à joindre le numéro ? Réservez en ligne. On s\'occupe de tout pour vous.',
                  targetShapeBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  tooltipBackgroundColor: AppColors.white,
                  textColor: AppColors.textPrimary,
                  descTextStyle: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  tooltipBorderRadius: const BorderRadius.all(Radius.circular(16)),
                  overlayOpacity: 0.5,
                  disposeOnTap: true,
                  onBarrierClick: () async {
                    await PreferencesHelper.setBookButtonTutorialCompleted(true);
                    ShowCaseWidget.of(context).dismiss();
                  },
                  onTargetClick: () async {
                    await PreferencesHelper.setBookButtonTutorialCompleted(true);
                    ShowCaseWidget.of(context).dismiss();
                  },
                child: ElevatedButton.icon(
                  onPressed: professional.isAvailable
                      ? () => _navigateToBooking(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                      disabledBackgroundColor: AppColors.grey.withOpacity(0.5),
                      elevation: 2,
                  ),
                  icon: const Icon(Icons.calendar_today, size: 20),
                  label: Text(
                    localizations?.translate('book') ?? AppStrings.book,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

