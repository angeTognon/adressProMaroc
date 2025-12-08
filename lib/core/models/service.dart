class Service {
  final String id;
  final String name;
  final String icon;
  final String description;
  final String color;
  final bool? isActive;

  Service({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
    this.isActive,
  });

  // Factory constructor pour créer un Service depuis JSON
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      color: json['color']?.toString() ?? '#2196F3',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Méthode pour convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'description': description,
      'color': color,
      'isActive': isActive ?? true,
    };
  }
}

