import 'package:flutter/material.dart';

enum AppLocale { french, darija, arabic }

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Méthode pour obtenir les traductions
  String translate(String key) {
    final translations = _getTranslations();
    return translations[key] ?? key;
  }

  Map<String, String> _getTranslations() {
    switch (locale.languageCode) {
      case 'ar':
        return _arabicTranslations;
      case 'fr':
        if (locale.countryCode == 'MA' || locale.countryCode == 'DZ') {
          return _darijaTranslations;
        }
        return _frenchTranslations;
      default:
        return _frenchTranslations;
    }
  }

  // Traductions françaises
  static const Map<String, String> _frenchTranslations = {
    // App Info
    'app_name': 'Khadma',
    'app_tagline': 'Trouvez des professionnels au Maroc',
    
    // Splash
    'splash_loading': 'Chargement...',
    
    // Onboarding
    'onboarding_title_1': 'Trouvez des Professionnels',
    'onboarding_desc_1': 'Découvrez des milliers de professionnels qualifiés près de chez vous',
    'onboarding_title_2': 'Services de Qualité',
    'onboarding_desc_2': 'Connectez-vous avec des experts en plomberie, électricité et plus encore',
    'onboarding_title_3': 'Réservez Facilement',
    'onboarding_desc_3': 'Prenez rendez-vous en quelques clics et recevez un service de qualité',
    
    // Auth
    'login': 'Connexion',
    'register': 'Inscription',
    'email': 'Email',
    'password': 'Mot de passe',
    'confirm_password': 'Confirmer le mot de passe',
    'first_name': 'Prénom',
    'last_name': 'Nom',
    'phone': 'Téléphone',
    'forgot_password': 'Mot de passe oublié?',
    'dont_have_account': 'Vous n\'avez pas de compte?',
    'already_have_account': 'Vous avez déjà un compte?',
    'continue_as_guest': 'Continuer sans compte',
    'or': 'OU',
    
    // Home
    'search_placeholder': 'Rechercher un service...',
    'popular_services': 'Services Populaires',
    'nearby_professionals': 'Professionnels à Proximité',
    'all_services': 'Tous les Services',
    'filter': 'Filtrer',
    'sort': 'Trier',
    'my_bookings': 'Mes réservations',
    
    // Services
    'plumbing': 'Plomberie',
    'electricity': 'Électricité',
    'painting': 'Peinture',
    'carpentry': 'Menuiserie',
    'cleaning': 'Nettoyage',
    'gardening': 'Jardinage',
    'heating': 'Chauffage',
    'air_conditioning': 'Climatisation',
    
    // Professional
    'call': 'Appeler',
    'message': 'Message',
    'book': 'Réserver',
    'rating': 'Note',
    'reviews': 'Avis',
    'about': 'À propos',
    'services': 'Services',
    'location': 'Localisation',
    'price': 'Prix',
    'availability': 'Disponibilité',
    
    // Booking
    'booking': 'Réservation',
    'select_date': 'Sélectionner une date',
    'select_time': 'Sélectionner une heure',
    'booking_address': 'Adresse',
    'booking_notes': 'Notes (optionnel)',
    'booking_notes_hint': 'Informations supplémentaires pour le professionnel...',
    'confirm_booking': 'Confirmer la réservation',
    'booking_summary': 'Récapitulatif',
    'booking_success': 'Réservation confirmée!',
    'booking_success_message': 'Votre réservation a été confirmée. Le professionnel vous contactera bientôt.',
    'no_bookings': 'Aucune réservation',
    'no_bookings_message': 'Vous n\'avez pas encore de réservations',
    'booking_details': 'Détails de la réservation',
    'booking_date': 'Date et heure',
    'booking_status': 'Statut',
    'cancel_booking': 'Annuler la réservation',
    'view_details': 'Voir les détails',
    'total_amount': 'Montant total',
    
    // Filter
    'filter_by_location': 'Filtrer par localisation',
    'select_city': 'Sélectionner une ville',
    'select_district': 'Sélectionner un quartier',
    'all_cities': 'Toutes les villes',
    'all_districts': 'Tous les quartiers',
    'apply_filter': 'Appliquer le filtre',
    'clear_filter': 'Effacer le filtre',
    'no_results': 'Aucun résultat',
    'no_results_message': 'Aucun professionnel trouvé pour ces critères',
    
    // Professional Registration
    'professional_registration': 'Inscription Professionnel',
    'personal_information': 'Informations Personnelles',
    'professional_information': 'Informations Professionnelles',
    'additional_information': 'Informations Complémentaires',
    'additional_info_note': 'Ces informations faciliteront la vérification de votre compte',
    'has_business_name': 'J\'ai un nom d\'entreprise',
    'business_name': 'Nom d\'entreprise',
    'main_service': 'Service Principal',
    'services_offered': 'Services Offerts',
    'base_price': 'Prix de base (MAD)',
    'certification_number': 'Numéro de certification',
    'tax_id': 'Numéro fiscal',
    'verification_process': 'Processus de Vérification',
    'verification_info': 'Votre compte sera examiné par notre équipe. Vous recevrez une notification une fois votre compte vérifié. Cela peut prendre 24-48h.',
    'submit': 'Soumettre',
    'address': 'Adresse',
    'description': 'Description',
    'professional_login': 'Connexion Professionnel',
    'become_professional': 'Devenir Professionnel',
    'professional_dashboard': 'Tableau de bord',
    'registration_submitted': 'Inscription Soumise!',
    'welcome': 'Bienvenue',
    'account_status': 'Statut du compte',
    'pending_verification': 'En attente de vérification',
    'service': 'Service',
    
    // Auth & Login
    'login_required': 'Connexion requise',
    'must_login_to_book': 'Vous devez être connecté pour réserver un service.',
    'create_account_or_login': 'Créer un compte ou se connecter',
    'phone_copied': 'Numéro copié',
    
    // Booking & Showcase
    'book_easily': 'Réservez facilement',
    'book_easily_description': 'Vous n\'arrivez pas à joindre le numéro ? Réservez en ligne. On s\'occupe de tout pour vous.',
    
    // Currency & Availability
    'currency': 'MAD',
    'available': 'Disponible',
    'not_available': 'Non disponible',
    
    // Privacy
    'privacy_policy': 'Politique de confidentialité',
    'terms_of_service': 'Conditions d\'utilisation',
    
    // Common
    'skip': 'Passer',
    'next': 'Suivant',
    'back': 'Retour',
    'done': 'Terminé',
    'cancel': 'Annuler',
    'save': 'Enregistrer',
    'confirm': 'Confirmer',
    'edit': 'Modifier',
    'logout': 'Déconnexion',
  };

  // Traductions Darija
  static const Map<String, String> _darijaTranslations = {
    // App Info
    'app_name': 'Khadma',
    'app_tagline': 'L9awed 3la m7arfin f lmaghrib',
    
    // Splash
    'splash_loading': 'Khdam...',
    
    // Onboarding
    'onboarding_title_1': 'L9awed 3la m7arfin',
    'onboarding_desc_1': 'L9awed bzaf dyal m7arfin li khdamin f l9rib dyalek',
    'onboarding_title_2': 'Khadma b kwalita',
    'onboarding_desc_2': 'Rbot m3a m7arfin f lplomberie, l3adawiya w ktar',
    'onboarding_title_3': 'Reserver b sahla',
    'onboarding_desc_3': '3emel rendez-vous b 9lil dyal clicks w khlas',
    
    // Auth
    'login': 'D5ol',
    'register': 'Kteb 3lik',
    'email': 'Email',
    'password': 'Lmot d pass',
    'confirm_password': 'Akked lmot d pass',
    'first_name': 'Lism d lwl',
    'last_name': 'Lism d tani',
    'phone': 'Tilifoun',
    'forgot_password': 'Nset lmot d pass?',
    'dont_have_account': 'M3andkch compte?',
    'already_have_account': '3andek compte?',
    'continue_as_guest': 'Kmel bla compte',
    'or': 'WLA',
    
    // Home
    'search_placeholder': 'Qleb 3la service...',
    'popular_services': 'Services li meshourin',
    'nearby_professionals': 'M7arfin li f l9rib',
    'all_services': 'Kul services',
    'filter': 'Filtrer',
    'sort': 'Rtb',
    'my_bookings': 'Reservations dyalia',
    
    // Services
    'plumbing': 'Plomberie',
    'electricity': 'L3adawiya',
    'painting': 'Tbikh',
    'carpentry': 'Najara',
    'cleaning': 'Tanzif',
    'gardening': 'Ras lkhdira',
    'heating': 'Taskhoun',
    'air_conditioning': 'Klime',
    
    // Professional
    'call': '9tel',
    'message': 'Msaj',
    'book': 'Reserver',
    'rating': 'Not',
    'reviews': 'Ara2',
    'about': '3la 7awl',
    'services': 'Services',
    'location': 'Mkan',
    'price': 'Thaman',
    'availability': 'Kayn',
    
    // Booking
    'booking': 'Reservation',
    'select_date': 'Khtar tarix',
    'select_time': 'Khtar sa3a',
    'booking_address': 'L3nwan',
    'booking_notes': 'Notat (mashi lazma)',
    'booking_notes_hint': 'Ma3lumat zyada l lm7aref...',
    'confirm_booking': 'Akked lreservation',
    'booking_summary': 'Resume',
    'booking_success': 'Reservation t3akkdat!',
    'booking_success_message': 'Reservation dyalek t3akkdat. Lm7aref ghadi y9tel fik bchwiyya',
    'no_bookings': 'Mafi walou reservations',
    'no_bookings_message': 'Mazal ma3andekch reservations',
    'booking_details': 'Tfasyil d reservation',
    'booking_date': 'Tarix w sa3a',
    'booking_status': '7ala',
    'cancel_booking': 'Sket lreservation',
    'view_details': 'Chof ttfasyil',
    'total_amount': 'Lmablag kollshi',
    
    // Filter
    'filter_by_location': 'Filtrer b lmkan',
    'select_city': 'Khtar madina',
    'select_district': 'Khtar l9arya',
    'all_cities': 'Kul lmdin',
    'all_districts': 'Kul l9raya',
    'apply_filter': 'Ttbiq lfilter',
    'clear_filter': 'Ms7 lfilter',
    'no_results': 'Mafi walou',
    'no_results_message': 'Ma9ltch 7ta m7aref b had lcritères',
    
    // Professional Registration
    'professional_registration': 'Kteb 3lik 7aref',
    'personal_information': 'Ma3lumat shakhsiya',
    'professional_information': 'Ma3lumat 7arefia',
    'additional_information': 'Ma3lumat zyada',
    'additional_info_note': 'Had lma3lumat ghadi tshel 3la tverification d compte dyalek',
    'has_business_name': '3andi smiya d shrika',
    'business_name': 'Smiya d shrika',
    'main_service': 'Service rassi',
    'services_offered': 'Services li kadi7der',
    'base_price': 'Thman assassi (MAD)',
    'certification_number': 'Raqm tthqiq',
    'tax_id': 'Raqm dhariba',
    'verification_process': 'Mar7alat tverification',
    'verification_info': 'Compte dyalek ghadi yt3arad 3la tqiya d t3na. Ghadi tstlama notification wla compte dyalek tverifika. Yemken yakhod 24-48h.',
    'submit': 'Sellem',
    'address': 'L3nwan',
    'description': 'Twasif',
    'professional_login': 'D5ol 7aref',
    'become_professional': 'Sir 7aref',
    'professional_dashboard': 'Dashboard',
    'registration_submitted': 'Kteb 3lik sellem!',
    'welcome': 'Mar7ba',
    'account_status': '7ala d compte',
    'pending_verification': 'Kaystana tverification',
    'service': 'Service',
    
    // Auth & Login
    'login_required': 'Lazem d5ol',
    'must_login_to_book': 'Lazem d5ol bach t3emel reservation',
    'create_account_or_login': '3emel compte wla d5ol',
    'phone_copied': 'Raqm tnsakh',
    
    // Booking & Showcase
    'book_easily': 'Reserver b sahla',
    'book_easily_description': 'Ma9drtch t9tel 3la raqm? Reserver online. 7na khdamen 3lik.',
    
    // Currency & Availability
    'currency': 'MAD',
    'available': 'Kayn',
    'not_available': 'Makaynch',
    
    // Privacy
    'privacy_policy': 'Siyasat lkhosousiya',
    'terms_of_service': 'Shorout lkhidma',
    
    // Common
    'skip': 'Tsa7ba',
    'next': 'Jaya',
    'back': 'Rja3',
    'done': 'Kmlt',
    'cancel': 'Sket',
    'save': '7fed',
    'confirm': 'Akked',
    'edit': 'Bdel',
    'logout': 'Khrej',
  };

  // Traductions arabes
  static const Map<String, String> _arabicTranslations = {
    // App Info
    'app_name': 'خدمة',
    'app_tagline': 'ابحث عن محترفين في المغرب',
    
    // Splash
    'splash_loading': 'جاري التحميل...',
    
    // Onboarding
    'onboarding_title_1': 'ابحث عن محترفين',
    'onboarding_desc_1': 'اكتشف الآلاف من المحترفين المؤهلين بالقرب منك',
    'onboarding_title_2': 'خدمات عالية الجودة',
    'onboarding_desc_2': 'تواصل مع خبراء في السباكة والكهرباء والمزيد',
    'onboarding_title_3': 'احجز بسهولة',
    'onboarding_desc_3': 'احجز موعدًا ببضع نقرات واحصل على خدمة عالية الجودة',
    
    // Auth
    'login': 'تسجيل الدخول',
    'register': 'إنشاء حساب',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'confirm_password': 'تأكيد كلمة المرور',
    'first_name': 'الاسم الأول',
    'last_name': 'اسم العائلة',
    'phone': 'الهاتف',
    'forgot_password': 'نسيت كلمة المرور?',
    'dont_have_account': 'ليس لديك حساب?',
    'already_have_account': 'لديك حساب بالفعل?',
    'continue_as_guest': 'المتابعة كضيف',
    'or': 'أو',
    
    // Home
    'search_placeholder': 'ابحث عن خدمة...',
    'popular_services': 'الخدمات الشائعة',
    'nearby_professionals': 'محترفون قريبون',
    'all_services': 'جميع الخدمات',
    'filter': 'تصفية',
    'sort': 'ترتيب',
    'my_bookings': 'حجوزاتي',
    
    // Services
    'plumbing': 'السباكة',
    'electricity': 'الكهرباء',
    'painting': 'الدهن',
    'carpentry': 'النجارة',
    'cleaning': 'التنظيف',
    'gardening': 'البستنة',
    'heating': 'التدفئة',
    'air_conditioning': 'التكييف',
    
    // Professional
    'call': 'اتصال',
    'message': 'رسالة',
    'book': 'احجز',
    'rating': 'التقييم',
    'reviews': 'التقييمات',
    'about': 'حول',
    'services': 'الخدمات',
    'location': 'الموقع',
    'price': 'السعر',
    'availability': 'التوفر',
    
    // Booking
    'booking': 'الحجز',
    'select_date': 'اختر تاريخ',
    'select_time': 'اختر وقت',
    'booking_address': 'العنوان',
    'booking_notes': 'ملاحظات (اختياري)',
    'booking_notes_hint': 'معلومات إضافية للمحترف...',
    'confirm_booking': 'تأكيد الحجز',
    'booking_summary': 'ملخص',
    'booking_success': 'تم تأكيد الحجز!',
    'booking_success_message': 'تم تأكيد حجزك. سيتواصل معك المحترف قريبًا',
    'no_bookings': 'لا توجد حجوزات',
    'no_bookings_message': 'ليس لديك حجوزات حتى الآن',
    'booking_details': 'تفاصيل الحجز',
    'booking_date': 'التاريخ والوقت',
    'booking_status': 'الحالة',
    'cancel_booking': 'إلغاء الحجز',
    'view_details': 'عرض التفاصيل',
    'total_amount': 'المبلغ الإجمالي',
    
    // Filter
    'filter_by_location': 'تصفية حسب الموقع',
    'select_city': 'اختر المدينة',
    'select_district': 'اختر الحي',
    'all_cities': 'جميع المدن',
    'all_districts': 'جميع الأحياء',
    'apply_filter': 'تطبيق التصفية',
    'clear_filter': 'مسح التصفية',
    'no_results': 'لا توجد نتائج',
    'no_results_message': 'لم يتم العثور على محترفين بهذه المعايير',
    
    // Professional Registration
    'professional_registration': 'تسجيل محترف',
    'personal_information': 'المعلومات الشخصية',
    'professional_information': 'المعلومات المهنية',
    'additional_information': 'معلومات إضافية',
    'additional_info_note': 'هذه المعلومات ستسهل التحقق من حسابك',
    'has_business_name': 'لدي اسم شركة',
    'business_name': 'اسم الشركة',
    'main_service': 'الخدمة الرئيسية',
    'services_offered': 'الخدمات المقدمة',
    'base_price': 'السعر الأساسي (درهم)',
    'certification_number': 'رقم الشهادة',
    'tax_id': 'الرقم الضريبي',
    'verification_process': 'عملية التحقق',
    'verification_info': 'سيتم مراجعة حسابك من قبل فريقنا. ستتلقى إشعارًا بمجرد التحقق من حسابك. قد يستغرق هذا 24-48 ساعة.',
    'submit': 'إرسال',
    'address': 'العنوان',
    'description': 'الوصف',
    'professional_login': 'تسجيل دخول محترف',
    'become_professional': 'كن محترفًا',
    'professional_dashboard': 'لوحة التحكم',
    'registration_submitted': 'تم إرسال التسجيل!',
    'welcome': 'مرحبًا',
    'account_status': 'حالة الحساب',
    'pending_verification': 'في انتظار التحقق',
    'service': 'الخدمة',
    
    // Auth & Login
    'login_required': 'تسجيل الدخول مطلوب',
    'must_login_to_book': 'يجب عليك تسجيل الدخول لحجز خدمة.',
    'create_account_or_login': 'إنشاء حساب أو تسجيل الدخول',
    'phone_copied': 'تم نسخ الرقم',
    
    // Booking & Showcase
    'book_easily': 'احجز بسهولة',
    'book_easily_description': 'لا يمكنك الوصول إلى الرقم؟ احجز عبر الإنترنت. نحن نتعامل مع كل شيء لك.',
    
    // Currency & Availability
    'currency': 'درهم',
    'available': 'متاح',
    'not_available': 'غير متاح',
    
    // Privacy
    'privacy_policy': 'سياسة الخصوصية',
    'terms_of_service': 'شروط الخدمة',
    
    // Common
    'skip': 'تخطي',
    'next': 'التالي',
    'back': 'رجوع',
    'done': 'تم',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'confirm': 'تأكيد',
    'edit': 'تعديل',
    'logout': 'تسجيل الخروج',
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

