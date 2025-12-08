# Guide d'intégration API - Services

## 📋 Fichiers créés

### PHP (Backend)
1. **`insert_services.php`** - Script pour insérer les services dans la base de données
2. **`api/get_services.php`** - Endpoint API pour récupérer les services
3. **`db.php`** - Configuration de connexion à la base de données

### Flutter (Frontend)
1. **`lib/core/config/api_config.dart`** - Configuration de l'URL de base de l'API
2. **`lib/core/services/api_service.dart`** - Service pour appeler l'API
3. **Modifications dans :**
   - `lib/core/models/service.dart` - Ajout de `fromJson()` et `toJson()`
   - `lib/core/data/mock_data.dart` - Ajout de `getServicesFromApi()`
   - `lib/features/home/home_screen.dart` - Intégration du chargement depuis l'API

## 🚀 Installation et configuration

### 1. Base de données

#### Créer les tables
```bash
# Via navigateur web
Accédez à: http://votre-domaine.com/create_tables.php

# Ou via ligne de commande
php create_tables.php
```

#### Insérer les services
```bash
# Via navigateur web
Accédez à: http://votre-domaine.com/insert_services.php

# Ou via ligne de commande
php insert_services.php
```

### 2. Configuration de l'API dans Flutter

#### Modifier l'URL de base
Éditez le fichier `lib/core/config/api_config.dart` :

```dart
class ApiConfig {
  // Pour développement local (Android Emulator)
  static const String baseUrl = 'http://10.0.2.2';
  
  // Pour développement local (iOS Simulator / Web)
  // static const String baseUrl = 'http://localhost';
  
  // Pour production
  // static const String baseUrl = 'https://votre-domaine.com';
  
  // ...
}
```

**Note importante :**
- **Android Emulator** : Utilisez `http://10.0.2.2` pour accéder à `localhost`
- **iOS Simulator** : Utilisez `http://localhost` ou votre IP locale
- **Production** : Utilisez l'URL complète de votre serveur (HTTPS recommandé)

### 3. Installer les dépendances Flutter

```bash
flutter pub get
```

Le package `http` sera automatiquement installé.

## 📡 Utilisation de l'API

### Endpoint : GET Services

**URL :** `GET /api/get_services.php`

**Paramètres optionnels :**
- `lang` : Langue (`fr`, `ar`, `darija`) - Défaut: `fr`
- `active` : Filtrer uniquement les services actifs (`1`) - Défaut: `1`

**Exemple de requête :**
```
GET /api/get_services.php?lang=fr&active=1
```

**Réponse JSON :**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "name": "Plomberie",
      "icon": "🔧",
      "description": "Réparation et installation de plomberie",
      "color": "#2196F3",
      "isActive": true
    },
    ...
  ],
  "count": 8,
  "lang": "fr"
}
```

### Utilisation dans Flutter

#### Récupérer les services
```dart
import 'package:your_app/core/services/api_service.dart';

// Récupérer tous les services
final services = await ApiService.getServices();

// Récupérer avec une langue spécifique
final services = await ApiService.getServices(lang: 'fr');

// Récupérer un service par ID
final service = await ApiService.getServiceById('1', lang: 'fr');
```

#### Dans HomeScreen
Les services sont automatiquement chargés depuis l'API au démarrage. En cas d'erreur, l'application utilise les données mockées en fallback.

## 🔧 Gestion des erreurs

L'application Flutter gère automatiquement les erreurs :
- Si l'API n'est pas disponible, les services mockés sont utilisés
- Un indicateur de chargement s'affiche pendant le chargement
- Les erreurs sont loggées dans la console

## 📝 Structure des données

### Table `services`
- `id` (VARCHAR) - Identifiant unique
- `name` (VARCHAR) - Nom du service
- `name_fr` (VARCHAR) - Nom en français
- `name_ar` (VARCHAR) - Nom en arabe
- `name_darija` (VARCHAR) - Nom en darija
- `icon` (VARCHAR) - Icône/Emoji
- `description` (TEXT) - Description du service
- `color` (VARCHAR) - Couleur hexadécimale
- `is_active` (BOOLEAN) - Statut actif/inactif
- `created_at` (TIMESTAMP) - Date de création
- `updated_at` (TIMESTAMP) - Date de mise à jour

## 🔐 Sécurité

**À faire en production :**
1. Ajouter une authentification API (tokens, clés API)
2. Utiliser HTTPS au lieu de HTTP
3. Ajouter des validations côté serveur
4. Implémenter un rate limiting
5. Sanitizer les entrées utilisateur

## 🐛 Dépannage

### L'API ne répond pas
1. Vérifiez que le serveur PHP est démarré
2. Vérifiez les permissions des fichiers
3. Vérifiez l'URL dans `api_config.dart`
4. Vérifiez les logs d'erreur PHP

### CORS Errors (Web)
Ajoutez dans votre `.htaccess` ou configuration serveur :
```apache
Header set Access-Control-Allow-Origin "*"
Header set Access-Control-Allow-Methods "GET, POST, OPTIONS"
Header set Access-Control-Allow-Headers "Content-Type"
```

### Android Emulator ne peut pas accéder à l'API
- Vérifiez que vous utilisez `http://10.0.2.2` et non `localhost`
- Vérifiez que votre serveur PHP est accessible depuis votre machine

## ✅ Tests

Pour tester l'API :
```bash
# Via curl
curl http://votre-domaine.com/api/get_services.php

# Via navigateur
Ouvrez: http://votre-domaine.com/api/get_services.php
```

## 📚 Prochaines étapes

1. Ajouter une API pour les professionnels
2. Ajouter une API pour les réservations
3. Implémenter l'authentification
4. Ajouter le cache local pour améliorer les performances
5. Ajouter la pagination pour les grandes listes
