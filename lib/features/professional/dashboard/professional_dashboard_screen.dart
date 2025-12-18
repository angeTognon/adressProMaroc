import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/locale/app_localizations.dart';
import '../../../core/utils/preferences_helper.dart';
import '../auth/models/professional_registration_data.dart';
import '../auth/professional_login_screen.dart';

class ProfessionalDashboardScreen extends StatelessWidget {
  final ProfessionalRegistrationData? registrationData;

  const ProfessionalDashboardScreen({
    super.key,
    this.registrationData,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final showSuccessMessage = registrationData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('professional_dashboard') ?? 'Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await PreferencesHelper.clearAll();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const ProfessionalLoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSuccessMessage)
              Card(
                color: AppColors.secondary.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.secondary, size: 40),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations?.translate('registration_submitted') ?? 'Inscription Soumise!',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations?.translate('verification_info') ??
                                  'Votre compte est en attente de vérification. Vous recevrez une notification une fois approuvé.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (showSuccessMessage) const SizedBox(height: 24),
            Text(
              localizations?.translate('welcome') ?? 'Bienvenue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              registrationData?.displayName ?? 'Professionnel',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 32),
            // Informations du compte
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.translate('account_status') ?? 'Statut du compte',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⏳', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 8),
                              Text(
                                localizations?.translate('pending_verification') ?? 'En attente de vérification',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Informations professionnelles
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.translate('professional_information') ?? 'Informations Professionnelles',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (registrationData != null) ...[
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        context,
                        Icons.build,
                        localizations?.translate('service') ?? 'Service',
                        registrationData!.service,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        Icons.location_on,
                        localizations?.translate('location') ?? 'Localisation',
                        '${registrationData!.city}${registrationData!.district != null ? ', ${registrationData!.district}' : ''}',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        context,
                        Icons.attach_money,
                        localizations?.translate('price') ?? 'Prix',
                        '${registrationData!.basePrice.toStringAsFixed(0)} MAD',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

