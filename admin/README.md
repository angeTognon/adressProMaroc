# Interface d'Administration - Khadma

## 📋 Accès

Accédez à l'interface d'administration via :
```
https://afopeq.com/wp-content/back/khadma/admin/admin.php
```

**Mot de passe par défaut :** `admin123`

⚠️ **IMPORTANT :** Changez le mot de passe dans le fichier `admin.php` en modifiant la variable `$admin_password` !

## 🔐 Sécurité

Pour améliorer la sécurité en production :

1. **Changez le mot de passe** dans `admin.php`
2. **Ajoutez une authentification plus robuste** (tokens, sessions sécurisées)
3. **Protégez le dossier admin** avec `.htaccess`
4. **Utilisez HTTPS** uniquement
5. **Limitez les tentatives de connexion**

### Protection .htaccess (optionnel)

Créez un fichier `.htaccess` dans le dossier `admin/` :

```apache
# Protéger le dossier admin
AuthType Basic
AuthName "Administration Khadma"
AuthUserFile /chemin/vers/.htpasswd
Require valid-user

# Bloquer l'accès direct aux fichiers PHP dans sections/
<FilesMatch "\.php$">
    Order Deny,Allow
    Deny from all
</FilesMatch>
```

## 📊 Fonctionnalités

### ✅ Catégories
- Voir toutes les catégories
- Ajouter une catégorie
- Modifier une catégorie
- Supprimer une catégorie

### ✅ Services
- Voir tous les services
- Ajouter un service
- Modifier un service
- Supprimer un service
- Lier un service à une catégorie

### ✅ Professionnels
- Voir tous les professionnels
- Ajouter un professionnel
- Modifier un professionnel
- Supprimer un professionnel
- Gérer le statut (pending, verified, rejected, suspended)
- Gérer la disponibilité

### ✅ Utilisateurs
- Voir tous les utilisateurs
- Ajouter un utilisateur
- Modifier un utilisateur
- Supprimer un utilisateur
- Gérer le type (membre/invité)
- Activer/désactiver un compte

## 🎨 Interface

L'interface est moderne et responsive avec :
- Design épuré avec les couleurs de la marque
- Navigation par onglets
- Modales pour créer/modifier
- Tableaux pour visualiser les données
- Badges de statut colorés
- Confirmation avant suppression

## 📝 Utilisation

1. **Se connecter** avec le mot de passe
2. **Choisir un onglet** (Catégories, Services, Professionnels, Utilisateurs)
3. **Cliquer sur "Ajouter"** pour créer un nouvel élément
4. **Cliquer sur "Modifier"** pour éditer un élément
5. **Cliquer sur "Supprimer"** pour supprimer un élément (avec confirmation)

## 🔧 Structure des fichiers

```
admin/
├── admin.php              # Interface principale
└── sections/
    ├── categories.php     # Section catégories
    ├── services.php       # Section services
    ├── professionals.php  # Section professionnels
    └── users.php          # Section utilisateurs
```

## 🐛 Dépannage

### Erreur de connexion à la base de données
Vérifiez que le fichier `db.php` est accessible depuis `admin.php`

### Les modifications ne s'enregistrent pas
Vérifiez les permissions d'écriture sur la base de données

### L'interface ne s'affiche pas correctement
Vérifiez que tous les fichiers CSS/JS sont chargés et que JavaScript est activé
