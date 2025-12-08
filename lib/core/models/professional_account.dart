enum ProfessionalStatus {
  pending, // En attente de vérification
  verified, // Vérifié et approuvé
  rejected, // Refusé
  suspended, // Suspendu
}

class ProfessionalAccount {
  final String id;
  final String email;
  final String password; // Hashé en production
  final String firstName;
  final String lastName;
  final String phone;
  final String? businessName;
  final String service; // Catégorie principale
  final List<String> services; // Liste des services offerts
  final String city;
  final String? district;
  final String address;
  final String description;
  final double basePrice;
  final String? certificationNumber;
  final String? taxId; // Numéro fiscal
  final List<String>? documents; // URLs des documents (CNI, certificats, etc.)
  final ProfessionalStatus status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime? verifiedAt;
  final String? profileImage;
  final bool isAvailable;
  final double rating;
  final int reviewsCount;

  ProfessionalAccount({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.businessName,
    required this.service,
    required this.services,
    required this.city,
    this.district,
    required this.address,
    required this.description,
    required this.basePrice,
    this.certificationNumber,
    this.taxId,
    this.documents,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
    this.verifiedAt,
    this.profileImage,
    this.isAvailable = true,
    this.rating = 0.0,
    this.reviewsCount = 0,
  });

  String get fullName => '$firstName $lastName';
  String get displayName => businessName ?? fullName;

  ProfessionalStatus get currentStatus => status;

  String get statusText {
    switch (status) {
      case ProfessionalStatus.pending:
        return 'En attente de vérification';
      case ProfessionalStatus.verified:
        return 'Vérifié';
      case ProfessionalStatus.rejected:
        return 'Refusé';
      case ProfessionalStatus.suspended:
        return 'Suspendu';
    }
  }
}

