# 🔧 Solution aux problèmes

## Problème 1 : "Je ne vois rien dans mon app"

### Causes possibles :
1. ❌ Les services originaux ne sont pas dans la base de données
2. ❌ L'URL de l'API est incorrecte
3. ❌ L'API retourne une erreur 404

### ✅ Solutions :

#### 1. Insérer les services originaux dans la DB
Accédez à :
```
https://afopeq.com/wp-content/back/khadma/admin/insert_app_services.php
```

Ce script va insérer les 8 services originaux :
- 🔧 Plomberie
- ⚡ Électricité
- 🎨 Peinture
- 🪚 Menuiserie
- 🧹 Nettoyage
- 🌳 Jardinage
- 🔥 Chauffage
- ❄️ Climatisation

#### 2. Vérifier l'URL de l'API
L'URL complète devrait être :
```
https://afopeq.com/wp-content/back/khadma/api/get_services.php
```

Vérifiez dans votre navigateur que cette URL fonctionne et retourne du JSON.

#### 3. Vérifier les logs dans l'app Flutter
Quand vous lancez l'app, regardez la console Flutter. Vous devriez voir :
- ✅ `📡 URL tentée: https://afopeq.com/wp-content/back/khadma/api/get_services.php?lang=fr`
- ✅ Ou ❌ avec un message d'erreur détaillé

Si vous voyez une erreur 404, vérifiez que le fichier `api/get_services.php` existe sur votre serveur.

#### 4. Tester l'API directement
Dans votre navigateur, allez à :
```
https://afopeq.com/wp-content/back/khadma/api/get_services.php
```

Vous devriez voir du JSON avec vos services. Si vous voyez une erreur 404, le fichier n'est pas au bon endroit.

---

## Problème 2 : "Je ne vois pas les services dans le dashboard admin"

### ✅ Solution :

1. **Vérifiez l'onglet "Services"** (pas "Catégories")
   - Les services sont dans l'onglet "🔧 Services"
   - Les catégories sont dans l'onglet "📁 Catégories"

2. **Insérez les services originaux**
   - Exécutez : `admin/insert_app_services.php`
   - Puis retournez à l'admin et allez dans l'onglet "Services"

3. **Vérifiez la base de données**
   - Dans le dashboard admin, l'onglet Services devrait afficher tous les services
   - Si c'est vide, c'est que les services ne sont pas dans la table `services`

---

## 📋 Checklist de vérification

### ✅ Backend (Serveur PHP)
- [ ] Fichier `api/get_services.php` existe
- [ ] Fichier `db.php` est accessible depuis `api/get_services.php`
- [ ] Les services sont insérés dans la table `services` (exécuter `insert_app_services.php`)
- [ ] L'URL `https://afopeq.com/wp-content/back/khadma/api/get_services.php` retourne du JSON

### ✅ Frontend (App Flutter)
- [ ] L'URL dans `api_config.dart` est correcte : `baseUrl + '/api/get_services.php'`
- [ ] Le package `http` est installé (`flutter pub get`)
- [ ] Les logs montrent la bonne URL appelée
- [ ] En cas d'erreur, les services mockés sont affichés

---

## 🐛 Débogage

### Dans Flutter (console) :
```dart
// Vous devriez voir ces messages :
📡 URL tentée: https://afopeq.com/wp-content/back/khadma/api/get_services.php?lang=fr

// Si erreur :
❌ Erreur lors de la récupération des services: ...
⚠️ Erreur 404 : L'API n'est pas trouvée
```

### Dans le navigateur :
Testez directement l'API :
```
https://afopeq.com/wp-content/back/khadma/api/get_services.php
```

Réponse attendue :
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
  "count": 8
}
```

---

## 🔄 Actions immédiates à faire

1. **Exécutez `admin/insert_app_services.php`** pour insérer les 8 services
2. **Vérifiez dans le dashboard admin** → Onglet "Services" → Vous devriez voir 8 services
3. **Testez l'API** dans votre navigateur : `api/get_services.php`
4. **Rechargez l'app Flutter** et vérifiez les logs
5. **Si erreur 404** : Vérifiez que le fichier `api/get_services.php` est bien sur le serveur au bon endroit

---

## 📞 Si ça ne marche toujours pas

1. Vérifiez les logs serveur PHP
2. Vérifiez la console Flutter pour voir les erreurs exactes
3. Testez l'API directement dans le navigateur
4. Vérifiez que la table `services` contient bien des données (dans le dashboard admin)
