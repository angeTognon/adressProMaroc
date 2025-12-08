# Khadma - Application de Services au Maroc

Une application Flutter moderne qui permet aux utilisateurs de trouver des professionnels pour des services tels que la plomberie, l'électricité, la peinture, etc. au Maroc.

## 🎨 Caractéristiques

- **Splash Screen** - Écran de démarrage élégant
- **Onboarding** - Introduction interactive à l'application
- **Authentification** - Connexion et inscription
- **Mode Invité** - Possibilité de naviguer sans compte
- **Page d'accueil** - Liste des services populaires
- **Recherche** - Trouvez rapidement le service dont vous avez besoin
- **Détails Professionnel** - Informations complètes sur chaque professionnel
- **Design Moderne** - Interface utilisateur inspirée des couleurs du drapeau marocain

## 🎨 Couleurs

L'application utilise les couleurs du drapeau marocain :
- **Rouge** (#C1272D) - Couleur principale
- **Vert** (#006233) - Couleur secondaire
- **Jaune** (#FFC107) - Couleur d'accent

## 📱 Interfaces

### 1. Splash Screen
- Animation de démarrage
- Logo de l'application
- Redirection automatique vers onboarding ou login

### 2. Onboarding
- 3 pages d'introduction
- Indicateur de progression
- Bouton "Passer" pour ignorer

### 3. Authentification
- **Login** - Connexion avec email et mot de passe
- **Register** - Création de compte avec informations complètes
- **Mode Invité** - Continuer sans compte

### 4. Page d'Accueil
- Barre de recherche
- Liste des services populaires (Plomberie, Électricité, Peinture, etc.)
- Liste des professionnels à proximité
- Navigation vers les détails

### 5. Liste des Services
- Filtrage par catégorie de service
- Affichage des professionnels disponibles

### 6. Détails Professionnel
- Informations complètes
- Note et avis
- Localisation
- Prix
- Disponibilité
- Services offerts
- Actions : Appeler, Message, Réserver

## 🛠️ Technologies

- **Flutter** - Framework de développement
- **Material Design 3** - Design moderne
- **Google Fonts** - Typographie élégante
- **Shared Preferences** - Stockage local
- **Smooth Page Indicator** - Indicateurs d'onboarding

## 📦 Installation

1. Clonez le projet
```bash
git clone <repository-url>
cd adress_pro
```

2. Installez les dépendances
```bash
flutter pub get
```

3. Lancez l'application
```bash
flutter run
```

## 📁 Structure du Projet

```
lib/
├── core/
│   ├── constants/      # Constantes (couleurs, strings)
│   ├── models/         # Modèles de données
│   ├── theme/          # Thème de l'application
│   ├── utils/          # Utilitaires
│   └── data/           # Données mock
├── features/
│   ├── splash/         # Écran de démarrage
│   ├── onboarding/     # Pages d'introduction
│   ├── auth/           # Authentification
│   ├── home/           # Page d'accueil
│   ├── services/       # Liste des services
│   └── professional/   # Détails professionnel
└── shared/
    └── widgets/        # Widgets réutilisables
```

## 🚀 Fonctionnalités à Venir

- [ ] Intégration API backend
- [ ] Système de réservation complet
- [ ] Notifications push
- [ ] Géolocalisation
- [ ] Système de paiement
- [ ] Chat en temps réel
- [ ] Système de notation et avis
- [ ] Favoris
- [ ] Historique des commandes

## 📝 Licence

Ce projet est sous licence privée.

## 👨‍💻 Développement

Développé avec ❤️ pour le marché marocain
