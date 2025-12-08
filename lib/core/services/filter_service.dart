import '../models/professional.dart';
import '../models/location.dart';
import '../../features/filter/models/filter_model.dart';

class FilterService {
  static List<Professional> filterProfessionals(
    List<Professional> professionals,
    FilterModel filter,
  ) {
    var filtered = professionals;

    // Debug: afficher les filtres actifs
    print('🔍 Filtrage des professionnels:');
    print('   - Total avant filtrage: ${professionals.length}');
    print('   - Ville: ${filter.city}');
    print('   - Quartier: ${filter.district}');
    print('   - Service: ${filter.service}');

    // Filtre par ville
    if (filter.city != null && filter.city!.isNotEmpty) {
      final cityName = _getCityNameFromId(filter.city!);
      print('   - Nom de la ville recherchée: $cityName');
      
      // Normaliser le nom de la ville (enlever accents, espaces)
      final cityNormalized = _normalizeString(cityName);
      
      filtered = filtered.where((p) {
        final location = p.location.toLowerCase();
        final city = cityName.toLowerCase();
        final cityLower = cityNormalized.toLowerCase();
        
        // Normaliser aussi la location
        final locationNormalized = _normalizeString(p.location);
        
        // Vérifier si la location contient la ville de différentes façons
        final matches = 
            // Correspondance exacte (casse insensible)
            location == city ||
            // Contient la ville
            location.contains(city) || 
            locationNormalized.contains(cityLower) ||
            // Commence par la ville
            location.startsWith(city) ||
            locationNormalized.startsWith(cityLower) ||
            // Se termine par la ville
            location.endsWith(city) ||
            locationNormalized.endsWith(cityLower) ||
            // Dans les parties séparées par virgule
            location.split(',').any((part) {
              final partNormalized = _normalizeString(part.trim());
              return part.trim().toLowerCase() == city ||
                     part.trim().toLowerCase().contains(city) ||
                     partNormalized.contains(cityLower) ||
                     part.trim().toLowerCase().startsWith(city) ||
                     part.trim().toLowerCase().endsWith(city);
            });
        
        if (!matches && filtered.length <= 20) {
          // Ne logger que pour les 20 premiers pour éviter le spam
          print('     ✗ Exclu: ${p.name} - Location: "${p.location}" ne correspond pas à "$cityName"');
        }
        
        return matches;
      }).toList();
      
      print('   - Après filtre ville: ${filtered.length}');
    }

    // Filtre par quartier (si le location contient le quartier)
    if (filter.district != null && filter.district!.isNotEmpty) {
      final district = filter.district!.toLowerCase().trim();
      print('   - Quartier recherché: $district');
      
      filtered = filtered.where((p) {
        final location = p.location.toLowerCase();
        final matches = location.contains(district) ||
                       location.split(',').any((part) => part.trim() == district) ||
                       location.split(',').any((part) => part.trim().startsWith(district)) ||
                       location.split(',').any((part) => part.trim().endsWith(district));
        
        if (!matches) {
          print('     ✗ Exclu: ${p.name} - Location: "${p.location}" ne contient pas "$district"');
        }
        
        return matches;
      }).toList();
      
      print('   - Après filtre quartier: ${filtered.length}');
    }

    // Filtre par service
    if (filter.service != null && filter.service!.isNotEmpty) {
      final filterServiceLower = filter.service!.toLowerCase().trim();
      print('   - Service recherché: $filterServiceLower');
      
      filtered = filtered.where((p) {
        // Vérifier le service principal
        final serviceMatch = p.service.toLowerCase().trim() == filterServiceLower ||
                           p.service.toLowerCase().trim().contains(filterServiceLower) ||
                           filterServiceLower.contains(p.service.toLowerCase().trim());
        
        // Vérifier aussi dans la liste des services multiples
        bool servicesListMatch = false;
        if (p.services.isNotEmpty) {
          servicesListMatch = p.services.any((serviceName) {
            final serviceNameLower = serviceName.toLowerCase().trim();
            return serviceNameLower == filterServiceLower ||
                   serviceNameLower.contains(filterServiceLower) ||
                   filterServiceLower.contains(serviceNameLower);
          });
        }
        
        final matches = serviceMatch || servicesListMatch;
        
        if (!matches) {
          print('     ✗ Exclu: ${p.name} - Service: "${p.service}" (services: ${p.services}) ne correspond pas à "$filterServiceLower"');
        }
        
        return matches;
      }).toList();
      
      print('   - Après filtre service: ${filtered.length}');
    }

    // Filtre par note minimum
    if (filter.minRating != null) {
      filtered = filtered.where((p) => p.rating >= filter.minRating!).toList();
    }

    // Filtre par prix maximum
    if (filter.maxPrice != null) {
      filtered = filtered.where((p) => p.price <= filter.maxPrice!).toList();
    }

    print('   - Total après tous les filtres: ${filtered.length}');
    return filtered;
  }

  static String _getCityNameFromId(String cityId) {
    final cities = MoroccanCities.getCities();
    final city = cities.firstWhere(
      (c) => c.id == cityId,
      orElse: () => cities.first,
    );
    return city.name;
  }
  
  // Normaliser une chaîne (enlever accents, espaces multiples, etc.)
  static String _normalizeString(String str) {
    // Convertir en minuscules
    String normalized = str.toLowerCase();
    // Enlever les accents (approximation simple)
    normalized = normalized
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ô', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
    // Enlever les espaces multiples
    normalized = normalized.replaceAll(RegExp(r'\s+'), ' ');
    return normalized.trim();
  }

  static List<Professional> getProfessionalsByLocation(
    List<Professional> professionals,
    String? cityId,
    String? district,
  ) {
    if (cityId == null && district == null) {
      return professionals;
    }

    var filtered = professionals;

    if (cityId != null) {
      final cityName = _getCityNameFromId(cityId);
      filtered = filtered.where((p) {
        final location = p.location.toLowerCase();
        final city = cityName.toLowerCase();
        // Vérifier si la location contient la ville ou si elle commence par la ville
        return location.contains(city) || 
               location.startsWith(city) ||
               location.endsWith(city) ||
               location.split(',').any((part) => part.trim() == city);
      }).toList();
    }

    if (district != null) {
      filtered = filtered.where((p) {
        final location = p.location.toLowerCase();
        final dist = district.toLowerCase();
        // Vérifier si la location contient le quartier
        return location.contains(dist) ||
               location.split(',').any((part) => part.trim() == dist);
      }).toList();
    }

    return filtered;
  }
}

