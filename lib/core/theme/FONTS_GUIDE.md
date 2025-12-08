# Guide d'utilisation des polices Poppins

## Polices disponibles

L'application utilise les polices Poppins locales présentes dans `assets/fonts/` :
- **Poppins-Regular** (weight: 400) - Pour le texte normal
- **Poppins-Medium** (weight: 500) - Pour les titres moyens et labels
- **Poppins-Bold** (weight: 700) - Pour les titres principaux

## Application par type de texte

### 1. Titres Principaux (Display)
Utilisation : Grands titres, écrans d'accueil, titres de page
- `displayLarge` - 32px, Bold (w700)
- `displayMedium` - 28px, Bold (w700)
- `displaySmall` - 24px, Bold (w700)

```dart
Text('Titre principal', style: Theme.of(context).textTheme.displaySmall)
```

### 2. Titres de Section (Headline)
Utilisation : Titres de sections, sous-titres
- `headlineLarge` - 22px, Bold (w700)
- `headlineMedium` - 20px, Semi-Bold (w600)
- `headlineSmall` - 18px, Semi-Bold (w600)

```dart
Text('Titre de section', style: Theme.of(context).textTheme.headlineMedium)
```

### 3. Titres Moyens (Title)
Utilisation : Titres de cartes, labels importants
- `titleLarge` - 18px, Semi-Bold (w600)
- `titleMedium` - 16px, Medium (w500)
- `titleSmall` - 14px, Medium (w500)

```dart
Text('Titre', style: Theme.of(context).textTheme.titleLarge)
```

### 4. Corps de Texte (Body)
Utilisation : Texte principal, descriptions
- `bodyLarge` - 16px, Regular (w400)
- `bodyMedium` - 14px, Regular (w400)
- `bodySmall` - 12px, Regular (w400)

```dart
Text('Description', style: Theme.of(context).textTheme.bodyMedium)
```

### 5. Labels (Label)
Utilisation : Labels de formulaires, petits textes
- `labelLarge` - 14px, Medium (w500)
- `labelMedium` - 12px, Medium (w500)
- `labelSmall` - 11px, Medium (w500)

```dart
Text('Label', style: Theme.of(context).textTheme.labelMedium)
```

## Exemples d'utilisation dans l'application

### Splash Screen
- Titre principal : `displayMedium` ou `displaySmall`
- Sous-titre/Tagline : `bodyLarge`

### Onboarding
- Titre de chaque page : `displaySmall`
- Description : `bodyLarge`

### Login/Register
- Titre de page : `displaySmall`
- Labels de champs : `labelLarge`
- Texte d'aide : `bodyMedium`

### Page d'Accueil
- Titres de sections : `headlineMedium`
- Noms de services : `titleMedium`
- Descriptions : `bodyMedium`

### Détails Professionnel
- Nom du professionnel : `displaySmall`
- Service : `titleLarge`
- Description : `bodyLarge`
- Labels d'information : `labelMedium`

## Classes utilitaires

Un fichier `app_text_styles.dart` est disponible pour accéder directement aux styles si nécessaire :

```dart
import 'package:adress_pro/core/theme/app_text_styles.dart';

Text('Mon texte', style: AppTextStyles.bodyLarge(context))
```

## Recommandations

1. **Titres** : Utiliser Bold (w700) ou Semi-Bold (w600)
2. **Texte principal** : Utiliser Regular (w400)
3. **Labels et boutons** : Utiliser Medium (w500) ou Semi-Bold (w600)
4. **Cohérence** : Toujours utiliser les styles du thème pour garantir la cohérence

