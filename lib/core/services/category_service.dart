import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/category.dart';

class CategoryService {
  // Récupérer toutes les catégories
  static Future<List<Category>> getCategories({String? lang}) async {
    try {
      final url = Uri.parse(ApiConfig.getCategoriesUrl(lang: lang));
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
          final List<dynamic> categoriesData = jsonData['data'];
          return categoriesData.map((json) => Category.fromJson(json)).toList();
        } else {
          throw Exception('Erreur: ${jsonData['error'] ?? 'Données invalides'}');
        }
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      print('Erreur lors de la récupération des catégories: $e');
      rethrow;
    }
  }

  // Récupérer une catégorie par ID
  static Future<Category?> getCategoryById(String id, {String? lang}) async {
    try {
      final url = Uri.parse(ApiConfig.getCategoriesUrl(id: id, lang: lang));
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
          return Category.fromJson(jsonData['data']);
        }
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      print('Erreur lors de la récupération de la catégorie $id: $e');
      return null;
    }
    return null;
  }

  // Créer une catégorie
  static Future<Category> createCategory(Category category) async {
    try {
      final url = Uri.parse(ApiConfig.getCategoriesUrl());
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return category;
        } else {
          throw Exception('Erreur: ${jsonData['error']}');
        }
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      print('Erreur lors de la création de la catégorie: $e');
      rethrow;
    }
  }

  // Mettre à jour une catégorie
  static Future<bool> updateCategory(Category category) async {
    try {
      final url = Uri.parse(ApiConfig.getCategoriesUrl());
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['success'] == true;
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la catégorie: $e');
      rethrow;
    }
  }

  // Supprimer une catégorie
  static Future<bool> deleteCategory(String id) async {
    try {
      final url = Uri.parse('${ApiConfig.getCategoriesUrl()}?id=$id');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return jsonData['success'] == true;
      } else {
        throw Exception(
          'Erreur HTTP ${response.statusCode}: ${response.body}'
        );
      }
    } catch (e) {
      print('Erreur lors de la suppression de la catégorie: $e');
      rethrow;
    }
  }
}
