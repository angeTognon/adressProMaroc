import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/locale/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = localizations?.locale.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('privacy_policy') ?? 'Politique de Confidentialité'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction
            _buildSection(
              context,
              isArabic,
              localizations?.translate('privacy_policy_intro_title') ?? 
                'Introduction',
              localizations?.translate('privacy_policy_intro_content') ?? 
                'Khadma s\'engage à protéger votre vie privée et vos données personnelles. '
                'Cette politique de confidentialité explique comment nous collectons, utilisons et protégeons vos informations.',
            ),
            const SizedBox(height: 24),
            
            // Données collectées
            _buildSection(
              context,
              isArabic,
              localizations?.translate('data_collected_title') ?? 
                '1. Données que nous collectons',
              localizations?.translate('data_collected_content') ?? 
                'Nous collectons les informations suivantes :\n\n'
                '• Informations d\'identification (nom, prénom, email, numéro de téléphone)\n'
                '• Informations de localisation (ville, quartier, adresse)\n'
                '• Informations de réservation (date, heure, service demandé)\n'
                '• Informations techniques (adresse IP, type d\'appareil, cookies)\n\n'
                'Pour les professionnels, nous collectons également :\n'
                '• Informations professionnelles (certifications, numéro fiscal)\n'
                '• Historique des services rendus\n'
                '• Évaluations et commentaires clients',
            ),
            const SizedBox(height: 24),
            
            // Utilisation des données
            _buildSection(
              context,
              isArabic,
              localizations?.translate('data_usage_title') ?? 
                '2. Utilisation de vos données',
              localizations?.translate('data_usage_content') ?? 
                'Nous utilisons vos données pour :\n\n'
                '• Fournir et améliorer nos services\n'
                '• Faciliter les réservations entre utilisateurs et professionnels\n'
                '• Communiquer avec vous concernant vos réservations\n'
                '• Personnaliser votre expérience sur l\'application\n'
                '• Envoyer des notifications importantes\n'
                '• Respecter nos obligations légales et réglementaires',
            ),
            const SizedBox(height: 24),
            
            // Partage des données
            _buildSection(
              context,
              isArabic,
              localizations?.translate('data_sharing_title') ?? 
                '3. Partage de vos données',
              localizations?.translate('data_sharing_content') ?? 
                'Nous partageons vos données uniquement dans les cas suivants :\n\n'
                '• Avec les professionnels pour faciliter les réservations (nom, téléphone, adresse)\n'
                '• Avec nos partenaires techniques (hébergement, paiement) sous contrat de confidentialité\n'
                '• Si requis par la loi marocaine (autorités compétentes)\n\n'
                'Nous ne vendons JAMAIS vos données personnelles à des tiers à des fins commerciales.',
            ),
            const SizedBox(height: 24),
            
            // Données des professionnels
            _buildSection(
              context,
              isArabic,
              localizations?.translate('professional_data_title') ?? 
                '4. Données des professionnels',
              localizations?.translate('professional_data_content') ?? 
                'IMPORTANT - Concernant les professionnels présents sur notre plateforme :\n\n'
                'Certaines informations de professionnels ont été collectées depuis des sources publiques '
                'en ligne (sites web, annuaires) pour faciliter la mise en relation avec les utilisateurs.\n\n'
                'Si vous êtes un professionnel dont les données sont présentes sur Khadma et que vous souhaitez :\n'
                '• Demander la suppression de vos données\n'
                '• Corriger vos informations\n'
                '• Exercer vos droits RGPD\n\n'
                'Contactez-nous immédiatement à : privacy@khadma.ma\n\n'
                'Nous nous engageons à traiter votre demande dans les plus brefs délais (sous 30 jours).',
            ),
            const SizedBox(height: 24),
            
            // Vos droits (RGPD)
            _buildSection(
              context,
              isArabic,
              localizations?.translate('your_rights_title') ?? 
                '5. Vos droits (Conformité RGPD)',
              localizations?.translate('your_rights_content') ?? 
                'Conformément à la loi 09-08 relative à la protection des personnes physiques '
                'à l\'égard du traitement des données à caractère personnel au Maroc, vous avez le droit de :\n\n'
                '• Accéder à vos données personnelles\n'
                '• Demander la rectification de vos données\n'
                '• Demander la suppression de vos données\n'
                '• Vous opposer au traitement de vos données\n'
                '• Demander la limitation du traitement\n'
                '• Portabilité de vos données\n'
                '• Retirer votre consentement à tout moment\n\n'
                'Pour exercer ces droits, contactez-nous à : privacy@khadma.ma',
            ),
            const SizedBox(height: 24),
            
            // Sécurité
            _buildSection(
              context,
              isArabic,
              localizations?.translate('security_title') ?? 
                '6. Sécurité de vos données',
              localizations?.translate('security_content') ?? 
                'Nous mettons en œuvre des mesures techniques et organisationnelles appropriées pour protéger '
                'vos données contre tout accès non autorisé, perte, destruction ou altération.\n\n'
                'Cependant, aucune transmission de données sur Internet n\'est totalement sécurisée. '
                'Nous ne pouvons garantir la sécurité absolue de vos données.',
            ),
            const SizedBox(height: 24),
            
            // Cookies
            _buildSection(
              context,
              isArabic,
              localizations?.translate('cookies_title') ?? 
                '7. Cookies',
              localizations?.translate('cookies_content') ?? 
                'Notre application utilise des cookies pour améliorer votre expérience. '
                'Vous pouvez configurer votre navigateur pour refuser les cookies, '
                'mais cela peut affecter certaines fonctionnalités de l\'application.',
            ),
            const SizedBox(height: 24),
            
            // Modifications
            _buildSection(
              context,
              isArabic,
              localizations?.translate('policy_changes_title') ?? 
                '8. Modifications de cette politique',
              localizations?.translate('policy_changes_content') ?? 
                'Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. '
                'Les modifications seront publiées sur cette page avec la date de mise à jour. '
                'Nous vous encourageons à consulter régulièrement cette page.',
            ),
            const SizedBox(height: 24),
            
            // Contact
            _buildSection(
              context,
              isArabic,
              localizations?.translate('contact_title') ?? 
                '9. Contact',
              localizations?.translate('contact_content') ?? 
                'Pour toute question concernant cette politique de confidentialité ou vos données personnelles :\n\n'
                'Email : privacy@khadma.ma\n'
                'Adresse : [Votre adresse]\n'
                'Téléphone : [Votre téléphone]',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, bool isArabic, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        ),
      ],
    );
  }
}

