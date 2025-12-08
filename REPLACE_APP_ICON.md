# Guide pour remplacer l'icône de l'application

## Méthode 1 : Utiliser flutter_launcher_icons (Recommandé)

### Étape 1 : Ajouter le package
Ajoutez dans `pubspec.yaml` :

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.13.1
```

### Étape 2 : Configurer dans pubspec.yaml
Ajoutez cette section dans `pubspec.yaml` :

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/logo.png"
  min_sdk_android: 21
  remove_alpha_ios: true
```

### Étape 3 : Générer les icônes
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Méthode 2 : Remplacer manuellement (Si méthode 1 ne fonctionne pas)

### Pour iOS :
1. Ouvrez `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
2. Remplacez tous les fichiers PNG par votre logo redimensionné aux bonnes tailles :
   - 20x20@2x.png → 40x40px
   - 20x20@3x.png → 60x60px
   - 29x29@1x.png → 29x29px
   - 29x29@2x.png → 58x58px
   - 29x29@3x.png → 87x87px
   - 40x40@2x.png → 80x80px
   - 40x40@3x.png → 120x120px
   - 60x60@2x.png → 120x120px
   - 60x60@3x.png → 180x180px
   - 76x76@1x.png → 76x76px
   - 76x76@2x.png → 152x152px
   - 83.5x83.5@2x.png → 167x167px
   - 1024x1024@1x.png → 1024x1024px (App Store)

### Outils pour redimensionner :
- **En ligne** : https://www.appicon.co/ ou https://www.makeappicon.com/
- **macOS** : Utilisez Automator ou sips (ligne de commande)
- **Script sips** :
```bash
# Exemple pour créer une icône 1024x1024
sips -z 1024 1024 assets/logo.png --out ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png
```

## Méthode 3 : Utiliser un outil en ligne

1. Allez sur https://www.appicon.co/
2. Uploadez votre `assets/logo.png`
3. Téléchargez le pack d'icônes généré
4. Remplacez les fichiers dans `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

## Important

- L'icône doit être carrée (ratio 1:1)
- Format PNG avec fond transparent (recommandé)
- Taille minimale : 1024x1024px pour la meilleure qualité
- Pas de coins arrondis (iOS les ajoute automatiquement)

