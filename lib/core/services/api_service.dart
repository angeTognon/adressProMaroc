import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/service.dart';
import '../models/professional.dart';

class ApiService {
  // Récupérer tous les services
  static Future<List<Service>> getServices({String? lang}) async {
    try {
      final url = Uri.parse(ApiConfig.getServicesUrl(lang: lang));
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> servicesData = jsonData['data'];
          return servicesData.map((json) => Service.fromJson(json)).toList();
        } else {
          throw Exception('Erreur: ${jsonData['error'] ?? 'Données invalides'}');
        }
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      // Logger l'erreur détaillée
      print('❌ Erreur lors de la récupération des services: $e');
      if (e.toString().contains('404')) {
        print('⚠️ Erreur 404 : L\'API n\'est pas trouvée. Vérifiez l\'URL: ${ApiConfig.getServicesUrl(lang: lang)}');
      } else if (e.toString().contains('Failed host lookup')) {
        print('⚠️ Erreur de connexion : Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
      }
      rethrow; // Relancer l'erreur pour que l'app puisse la gérer
    }
  }

  // Récupérer un service par ID
  static Future<Service?> getServiceById(String id, {String? lang}) async {
    try {
      final services = await getServices(lang: lang);
      return services.firstWhere(
        (service) => service.id == id,
        orElse: () => throw Exception('Service non trouvé'),
      );
    } catch (e) {
      print('Erreur lors de la récupération du service $id: $e');
      return null;
    }
  }

  // Récupérer tous les professionnels
  static Future<List<Professional>> getProfessionals({
    String? serviceId,
    String? city,
    String? status,
    bool? available,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.getProfessionalsUrl(
        serviceId: serviceId,
        city: city,
        status: status,
        available: available,
      ));
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // Gérer les erreurs HTTP
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> professionalsData = jsonData['data'];
          
          // Debug: vérifier les données reçues
          print('✅ API Response - Nombre de professionnels: ${professionalsData.length}');
          if (professionalsData.isNotEmpty) {
            print('✅ API Response - Premier professionnel JSON: ${professionalsData.first}');
          }
          
          final professionals = professionalsData
              .map((json) {
                try {
                  return Professional.fromJson(json);
                } catch (e) {
                  print('❌ Erreur lors du parsing d\'un professionnel: $e');
                  print('   JSON: $json');
                  return null;
                }
              })
              .whereType<Professional>()
              .toList();
          
          print('✅ API Response - Professionnels parsés avec succès: ${professionals.length}');
          return professionals;
        } else {
          throw Exception('Erreur: ${jsonData['error'] ?? 'Données invalides'}');
        }
      } else {
        // Logger le body de la réponse pour debug
        print('❌ Erreur HTTP ${response.statusCode}');
        print('   Body: ${response.body}');
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      // Logger l'erreur détaillée
      print('❌ Erreur lors de la récupération des professionnels: $e');
      if (e.toString().contains('404')) {
        print('⚠️ Erreur 404 : L\'API n\'est pas trouvée. Vérifiez l\'URL: ${ApiConfig.getProfessionalsUrl()}');
      } else if (e.toString().contains('Failed host lookup')) {
        print('⚠️ Erreur de connexion : Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
      }
      rethrow;
    }
  }

  // Récupérer un professionnel par ID
  static Future<Professional?> getProfessionalById(String id) async {
    try {
      final professionals = await getProfessionals();
      return professionals.firstWhere(
        (professional) => professional.id == id,
        orElse: () => throw Exception('Professionnel non trouvé'),
      );
    } catch (e) {
      print('Erreur lors de la récupération du professionnel $id: $e');
      return null;
    }
  }

  // Récupérer les professionnels par service
  static Future<List<Professional>> getProfessionalsByService(String serviceName) async {
    try {
      // D'abord, trouver l'ID du service par son nom
      final services = await getServices();
      final serviceNameLower = serviceName.toLowerCase();
      final service = services.firstWhere(
        (s) {
          final sNameLower = s.name.toLowerCase();
          return sNameLower == serviceNameLower || s.name == serviceName;
        },
        orElse: () => throw Exception('Service non trouvé: $serviceName'),
      );
      
      // Récupérer les professionnels pour ce service
      return await getProfessionals(serviceId: service.id);
    } catch (e) {
      print('Erreur lors de la récupération des professionnels pour le service $serviceName: $e');
      return [];
    }
  }
}
