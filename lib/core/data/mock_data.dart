import '../models/service.dart';
import '../models/professional.dart';
import '../constants/app_strings.dart';
import '../services/api_service.dart';

class MockData {
  // Méthode pour récupérer les services depuis l'API
  static Future<List<Service>> getServicesFromApi({String? lang}) async {
    try {
      return await ApiService.getServices(lang: lang);
    } catch (e) {
      print('Erreur lors de la récupération des services depuis l\'API: $e');
      // En cas d'erreur, retourner les services mockés
      return getServicesMock();
    }
  }

  // Méthode de fallback avec les services mockés
  static List<Service> getServicesMock() {
    return [
      Service(
        id: '1',
        name: AppStrings.plumbing,
        icon: '🔧',
        description: 'Réparation et installation de plomberie',
        color: '#2196F3',
      ),
      Service(
        id: '2',
        name: AppStrings.electricity,
        icon: '⚡',
        description: 'Installation et réparation électrique',
        color: '#FFC107',
      ),
      Service(
        id: '3',
        name: AppStrings.painting,
        icon: '🎨',
        description: 'Peinture intérieure et extérieure',
        color: '#F44336',
      ),
      Service(
        id: '4',
        name: AppStrings.carpentry,
        icon: '🪚',
        description: 'Menuiserie et travaux sur mesure',
        color: '#795548',
      ),
      Service(
        id: '5',
        name: AppStrings.cleaning,
        icon: '🧹',
        description: 'Nettoyage professionnel',
        color: '#00BCD4',
      ),
      Service(
        id: '6',
        name: AppStrings.gardening,
        icon: '🌳',
        description: 'Jardinage et entretien d\'espaces verts',
        color: '#4CAF50',
      ),
      Service(
        id: '7',
        name: AppStrings.heating,
        icon: '🔥',
        description: 'Installation et réparation de chauffage',
        color: '#FF5722',
      ),
      Service(
        id: '8',
        name: AppStrings.airConditioning,
        icon: '❄️',
        description: 'Climatisation et ventilation',
        color: '#03A9F4',
      ),
    ];
  }

  static List<Professional> getProfessionals() {
    return [
      Professional(
        id: '1',
        name: 'Ahmed Benali',
        image: '👨‍🔧',
        service: AppStrings.plumbing,
        rating: 4.8,
        reviewsCount: 124,
        location: 'Maarif, Casablanca',
        phone: '+212 6XX XXX XXX',
        email: 'ahmed.benali@example.com',
        description: 'Plombier professionnel avec plus de 10 ans d\'expérience. Spécialisé dans les réparations d\'urgence et les installations complètes.',
        price: 250.0,
        isAvailable: true,
        services: ['Réparation fuites', 'Installation sanitaires', 'Débouchage'],
      ),
      Professional(
        id: '2',
        name: 'Fatima Alaoui',
        image: '👩‍🔌',
        service: AppStrings.electricity,
        rating: 4.9,
        reviewsCount: 89,
        location: 'Agdal, Rabat',
        phone: '+212 6XX XXX XXX',
        email: 'fatima.alaoui@example.com',
        description: 'Électricienne certifiée, spécialisée dans les installations résidentielles et commerciales. Service rapide et fiable.',
        price: 300.0,
        isAvailable: true,
        services: ['Installation électrique', 'Dépannage', 'Mise aux normes'],
      ),
      Professional(
        id: '3',
        name: 'Youssef Amrani',
        image: '👨‍🎨',
        service: AppStrings.painting,
        rating: 4.7,
        reviewsCount: 156,
        location: 'Gueliz, Marrakech',
        phone: '+212 6XX XXX XXX',
        email: 'youssef.amrani@example.com',
        description: 'Peintre professionnel avec une grande expertise en décoration intérieure. Qualité supérieure garantie.',
        price: 200.0,
        isAvailable: true,
        services: ['Peinture intérieure', 'Peinture extérieure', 'Revêtement'],
      ),
      Professional(
        id: '4',
        name: 'Khadija Tazi',
        image: '👩‍💼',
        service: AppStrings.cleaning,
        rating: 4.6,
        reviewsCount: 203,
        location: 'Ain Diab, Casablanca',
        phone: '+212 6XX XXX XXX',
        email: 'khadija.tazi@example.com',
        description: 'Service de nettoyage professionnel pour maisons, bureaux et espaces commerciaux. Équipe expérimentée.',
        price: 150.0,
        isAvailable: true,
        services: ['Nettoyage résidentiel', 'Nettoyage commercial', 'Nettoyage après travaux'],
      ),
      Professional(
        id: '5',
        name: 'Mehdi Bensaid',
        image: '👨‍🌾',
        service: AppStrings.gardening,
        rating: 4.8,
        reviewsCount: 98,
        location: 'Malabata, Tanger',
        phone: '+212 6XX XXX XXX',
        email: 'mehdi.bensaid@example.com',
        description: 'Paysagiste professionnel spécialisé dans l\'aménagement et l\'entretien d\'espaces verts. Créations uniques.',
        price: 180.0,
        isAvailable: false,
        services: ['Aménagement jardin', 'Tonte pelouse', 'Taille arbres'],
      ),
      Professional(
        id: '6',
        name: 'Laila Idrissi',
        image: '👩‍🔧',
        service: AppStrings.plumbing,
        rating: 4.9,
        reviewsCount: 145,
        location: 'Fès el-Bali, Fès',
        phone: '+212 6XX XXX XXX',
        email: 'laila.idrissi@example.com',
        description: 'Plombière expérimentée, disponible 24/7 pour les urgences. Service de qualité et prix compétitifs.',
        price: 230.0,
        isAvailable: true,
        services: ['Urgences 24/7', 'Réparation', 'Installation'],
      ),
    ];
  }

  static List<Professional> getProfessionalsByService(String serviceName) {
    return getProfessionals()
        .where((professional) => professional.service == serviceName)
        .toList();
  }

  // Méthode pour récupérer les professionnels depuis l'API
  static Future<List<Professional>> getProfessionalsFromApi({
    String? serviceId,
    String? city,
    String? status,
    bool? available,
  }) async {
    try {
      return await ApiService.getProfessionals(
        serviceId: serviceId,
        city: city,
        status: status,
        available: available,
      );
    } catch (e) {
      print('Erreur lors de la récupération des professionnels depuis l\'API: $e');
      // En cas d'erreur, retourner les professionnels mockés
      return getProfessionals();
    }
  }

  // Méthode pour récupérer les professionnels par service depuis l'API
  static Future<List<Professional>> getProfessionalsByServiceFromApi(String serviceName) async {
    try {
      return await ApiService.getProfessionalsByService(serviceName);
    } catch (e) {
      print('Erreur lors de la récupération des professionnels par service depuis l\'API: $e');
      // En cas d'erreur, retourner les professionnels mockés filtrés
      return getProfessionalsByService(serviceName);
    }
  }
}

