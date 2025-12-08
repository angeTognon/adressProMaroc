class Category {
  final String id;
  final String name;
  final String icon;
  final String description;
  final String color;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
  });

  // Factory constructor pour créer une Category depuis JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      color: json['color']?.toString() ?? '#2196F3',
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
    };
  }
}
