class Location {
  final String city;
  final String? district;

  Location({
    required this.city,
    this.district,
  });

  String get fullLocation {
    if (district != null && district!.isNotEmpty) {
      return '$district, $city';
    }
    return city;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.city == city &&
        other.district == district;
  }

  @override
  int get hashCode => city.hashCode ^ district.hashCode;
}

class City {
  final String id;
  final String name;
  final List<String> districts;

  City({
    required this.id,
    required this.name,
    this.districts = const [],
  });
}

class MoroccanCities {
  static List<City> getCities() {
    return [
      City(
        id: 'casablanca',
        name: 'Casablanca',
        districts: [
          'Maarif',
          'Ain Diab',
          'Anfa',
          'Hay Riad',
          'Oasis',
          'Roches Noires',
          'Derb Sultan',
          'Hay Hassani',
          'Bourgogne',
          'Verdin',
          'Avenue Bordeaux',
          'Sidi Bernoussi',
          'Sidi Moumen',
          'Ain Sebaa',
          'Yasmina',
          'Ain Harrouda',
        ],
      ),
      City(
        id: 'rabat',
        name: 'Rabat',
        districts: [
          'Agdal',
          'Hay Riad',
          'Touarga',
          'Hassan',
          'Akkari',
          'El Akkari',
          'Youssoufia',
          'Takaddoum',
          'Yacoub Al Mansour',
        ],
      ),
      City(
        id: 'marrakech',
        name: 'Marrakech',
        districts: [
          'Gueliz',
          'Hivernage',
          'Agdal',
          'Palmeraie',
          'Médina',
          'Semlalia',
          'Al Massira',
          'Abwab Marrakech',
        ],
      ),
      City(
        id: 'tanger',
        name: 'Tanger',
        districts: [
          'Malabata',
          'Boulevard Pasteur',
          'Ibn Battouta',
          'Marshan',
          'Old Mountain',
        ],
      ),
      City(
        id: 'fes',
        name: 'Fès',
        districts: [
          'Fès el-Bali',
          'Fès el-Jdid',
          'Zouagha',
          'Hay Riad',
        ],
      ),
      City(
        id: 'agadir',
        name: 'Agadir',
        districts: [
          'Hay Mohammadi',
          'Tilila',
          'Talborjt',
          'Hay Al Amal',
        ],
      ),
      City(
        id: 'kenitra',
        name: 'Kenitra',
        districts: [
          'la ville haute',
          'La Ville Haute',
          'Saknia',
        ],
      ),
      City(
        id: 'sale',
        name: 'Salé',
        districts: [
          'Tabriquet',
          'Hay Essalam',
          'Hay Rahma',
          'Laayayda',
        ],
      ),
      City(
        id: 'temara',
        name: 'Temara',
        districts: [
          'Al Wifak',
        ],
      ),
      City(
        id: 'meknes',
        name: 'Meknès',
        districts: [
          'Ville Nouvelle',
        ],
      ),
      City(
        id: 'sidi_bennour',
        name: 'Sidi Bennour',
        districts: [],
      ),
    ];
  }
}

