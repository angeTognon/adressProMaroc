# Instructions - Interface d'Administration

## 🔧 Problèmes corrigés

### 1. **Boutons qui ne fonctionnent pas**
✅ **Corrigé** : Les fonctions JavaScript sont maintenant dans le scope global (`window.openModal`, etc.)
✅ **Corrigé** : Les URLs fetch utilisent maintenant `window.location.href` au lieu de chaînes vides

### 2. **Aucune catégorie affichée**
✅ **Corrigé** : La fonction `getAllRecords` gère maintenant mieux les erreurs
✅ **Solution** : Utilisez le fichier `insert_test_data.php` pour insérer des données de test

## 🚀 Étapes pour résoudre les problèmes

### Étape 1 : Insérer des données de test

1. Accédez à : `https://afopeq.com/wp-content/back/khadma/admin/insert_test_data.php`
2. Ce script va insérer :
   - 3 catégories de test
   - 3 services de test
3. Ensuite, retournez à l'interface admin

### Étape 2 : Vérifier que tout fonctionne

1. **Ouvrir la console du navigateur** (F12) pour voir les erreurs éventuelles
2. **Tester les boutons** :
   - Cliquer sur "Ajouter une catégorie"
   - Le modal devrait s'ouvrir
   - Remplir le formulaire
   - Cliquer sur "Enregistrer"

### Étape 3 : Si les boutons ne fonctionnent toujours pas

1. **Vérifier la console JavaScript** (F12 > Console)
2. **Vérifier les erreurs PHP** dans les logs serveur
3. **Vérifier que les fichiers sont bien uploadés** sur le serveur

## 📝 Utilisation du CRUD

### Créer un élément

1. Cliquer sur le bouton **"➕ Ajouter"**
2. Remplir le formulaire (ID optionnel - auto-généré si vide)
3. Cliquer sur **"Enregistrer"**

### Modifier un élément

1. Cliquer sur **"✏️ Modifier"** sur une ligne
2. Le modal s'ouvre avec les données pré-remplies
3. Modifier les champs souhaités
4. Cliquer sur **"Enregistrer"**

### Supprimer un élément

1. Cliquer sur **"🗑️ Supprimer"** sur une ligne
2. Confirmer la suppression
3. L'élément est supprimé et la page se recharge

## 🔍 Débogage

### Vérifier que les fonctions JavaScript sont chargées

Ouvrez la console (F12) et tapez :
```javascript
typeof window.openModal
```
Ça devrait retourner `"function"`. Si ça retourne `"undefined"`, il y a un problème de chargement.

### Vérifier les erreurs AJAX

Dans la console, regardez les requêtes réseau (Onglet Network) lors d'un clic sur un bouton.
- Si vous voyez une erreur 500, c'est un problème PHP
- Si vous voyez une erreur 404, le fichier n'est pas trouvé
- Si vous voyez une erreur CORS, vérifiez les headers

### Vérifier les erreurs PHP

Activez l'affichage des erreurs PHP dans `admin.php` en ajoutant en haut :
```php
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

## ✅ Fonctionnalités disponibles

### ✅ Catégories
- ✅ Créer une catégorie
- ✅ Modifier une catégorie
- ✅ Supprimer une catégorie
- ✅ Voir toutes les catégories

### ✅ Services
- ✅ Créer un service
- ✅ Modifier un service
- ✅ Supprimer un service
- ✅ Lier un service à une catégorie
- ✅ Voir tous les services

### ✅ Professionnels
- ✅ Créer un professionnel
- ✅ Modifier un professionnel
- ✅ Supprimer un professionnel
- ✅ Gérer le statut (pending, verified, rejected, suspended)
- ✅ Voir tous les professionnels

### ✅ Utilisateurs
- ✅ Créer un utilisateur
- ✅ Modifier un utilisateur
- ✅ Supprimer un utilisateur
- ✅ Gérer le type (membre/invité)
- ✅ Voir tous les utilisateurs

## 🐛 Problèmes connus et solutions

### Le modal ne s'ouvre pas
- **Solution** : Vérifiez la console JavaScript
- **Solution** : Vérifiez que `window.openModal` existe

### Erreur lors de la sauvegarde
- **Solution** : Vérifiez que tous les champs requis sont remplis
- **Solution** : Vérifiez les logs PHP

### Aucune donnée affichée
- **Solution** : Exécutez `insert_test_data.php`
- **Solution** : Vérifiez la connexion à la base de données
