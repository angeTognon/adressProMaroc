class ApiConfig {
  // Modifiez cette URL avec l'URL de votre serveur
  // Pour développement local: 'http://10.0.2.2' (Android emulator)
  // Pour développement local: 'http://localhost' (iOS simulator)
  // Pour production: 'https://votre-domaine.com'
  static const String baseUrl = 'https://afopeq.com/wp-content/back/khadma';
  
  // Endpoints
  static const String servicesEndpoint = '/api/get_services.php';
  static const String categoriesEndpoint = '/api/categories_api.php';
  static const String professionalsEndpoint = '/api/get_professionals.php';
  
  // Helper pour obtenir l'URL complète
  static String getServicesUrl({String? lang}) {
    String url = '$baseUrl$servicesEndpoint';
    if (lang != null) {
      url += '?lang=$lang';
    }
    return url;
  }
  
  static String getCategoriesUrl({String? lang, String? id}) {
    String url = '$baseUrl$categoriesEndpoint';
    List<String> params = [];
    if (lang != null) params.add('lang=$lang');
    if (id != null) params.add('id=$id');
    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }
    return url;
  }
  
  static String getProfessionalsUrl({
    String? serviceId,
    String? city,
    String? status,
    bool? available,
  }) {
    String url = '$baseUrl$professionalsEndpoint';
    List<String> params = [];
    if (serviceId != null && serviceId.isNotEmpty) {
      params.add('service_id=$serviceId');
    }
    if (city != null && city.isNotEmpty) {
      params.add('city=$city');
    }
    if (status != null && status.isNotEmpty) {
      params.add('status=$status');
    }
    if (available != null) {
      params.add('available=${available.toString()}');
    }
    if (params.isNotEmpty) {
      url += '?${params.join('&')}';
    }
    return url;
  }
}
