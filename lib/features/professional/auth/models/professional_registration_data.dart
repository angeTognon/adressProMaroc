class ProfessionalRegistrationData {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String? businessName;
  final String service;
  final List<String> services;
  final String city;
  final String? district;
  final String address;
  final String description;
  final double basePrice;
  final String? certificationNumber;
  final String? taxId;

  ProfessionalRegistrationData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
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
  });

  String get fullName => '$firstName $lastName';
  String get displayName => businessName ?? fullName;
}

