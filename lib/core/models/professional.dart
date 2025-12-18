class Professional {
  final String id;
  final String name;
  final String image;
  final String service;
  final double rating;
  final int reviewsCount;
  final String location;
  final String phone;
  final String email;
  final String description;
  final double price;
  final bool isAvailable;
  final List<String> services;

  Professional({
    required this.id,
    required this.name,
    required this.image,
    required this.service,
    required this.rating,
    required this.reviewsCount,
    required this.location,
    required this.phone,
    required this.email,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.services,
  });

  // Factory constructor pour créer un Professional depuis JSON
  factory Professional.fromJson(Map<String, dynamic> json) {
    // Convertir la liste des services depuis JSON
    List<String> servicesList = [];
    if (json['services'] != null) {
      if (json['services'] is List) {
        servicesList = List<String>.from(json['services']);
      }
    }

    // Construire le nom complet
    String name = json['name'] ?? '';
    if (name.isEmpty) {
      String firstName = json['first_name'] ?? '';
      String lastName = json['last_name'] ?? '';
      String businessName = json['business_name'] ?? '';
      name = businessName.isNotEmpty 
          ? businessName 
          : '$firstName $lastName'.trim();
    }

    // Construire le service principal
    String service = json['service'] ?? '';
    if (service.isEmpty) {
      service = json['service_name_fr'] ?? 
                json['service_name'] ?? 
                '';
    }

    // Construire la localisation
    String location = json['location']?.toString().trim() ?? '';
    if (location.isEmpty) {
      String district = (json['district']?.toString().trim() ?? '');
      String city = (json['city']?.toString().trim() ?? '');
      if (district.isNotEmpty && city.isNotEmpty) {
        location = '$district, $city';
      } else if (city.isNotEmpty) {
        location = city;
      } else if (district.isNotEmpty) {
        location = district;
      }
    }

    return Professional(
      id: json['id']?.toString() ?? '',
      name: name,
      image: json['image'] ?? json['profile_image'] ?? '👔',
      service: service,
      rating: (json['rating'] != null) 
          ? double.tryParse(json['rating'].toString()) ?? 0.0 
          : 0.0,
      reviewsCount: json['reviews_count'] ?? 0,
      location: location,
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] != null || json['base_price'] != null)
          ? double.tryParse((json['price'] ?? json['base_price']).toString()) ?? 0.0
          : 0.0,
      isAvailable: json['isAvailable'] ?? 
                   (json['is_available'] == 1 || json['is_available'] == true) ??
                   false,
      services: servicesList,
    );
  }

  // Méthode pour convertir en JSON (optionnelle, pour debug)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'service': service,
      'rating': rating,
      'reviews_count': reviewsCount,
      'location': location,
      'phone': phone,
      'email': email,
      'description': description,
      'price': price,
      'is_available': isAvailable,
      'services': services,
    };
  }
}

