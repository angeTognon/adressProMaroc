# Guide de correction du crash au démarrage

## Problème
L'application se ferme automatiquement au démarrage sur iPhone.

## Corrections apportées

### 1. Initialisation Flutter Binding
- Ajout de `WidgetsFlutterBinding.ensureInitialized()` dans `main()`
- Nécessaire pour certaines opérations asynchrones avant `runApp()`

### 2. Gestion des erreurs globales
- Ajout de `FlutterError.onError` pour capturer les erreurs Flutter
- Ajout de `PlatformDispatcher.instance.onError` pour les erreurs non capturées

### 3. Protection du logo
- Ajout d'un `errorBuilder` sur `Image.asset` pour le logo
- Si l'image n'est pas trouvée, affiche une icône de fallback

### 4. Protection de la navigation
- Ajout d'un `try-catch` dans `_navigateToNext()`
- En cas d'erreur, redirige vers `AuthWrapper` par défaut

## Prochaines étapes

### 1. Reconstruire l'application
```bash
flutter clean
flutter pub get
flutter build ios --release
```

### 2. Vérifier les logs
Pour voir les erreurs exactes, connectez votre iPhone et utilisez :
```bash
# Voir les logs en temps réel
flutter run --release -d [ID_DE_VOTRE_IPHONE] -v

# Ou via Xcode
# Ouvrez Xcode > Window > Devices and Simulators
# Sélectionnez votre iPhone > View Device Logs
```

### 3. Vérifications supplémentaires

#### A. Vérifier que le logo existe
```bash
ls -la assets/logo.png
```

#### B. Vérifier les permissions iOS
Dans `ios/Runner/Info.plist`, assurez-vous que les permissions nécessaires sont déclarées si vous utilisez :
- Localisation
- Caméra
- Photos
- etc.

#### C. Tester en mode Debug d'abord
```bash
flutter run --debug
```
Le mode debug affichera les erreurs dans la console.

### 4. Vérifier les dépendances
Assurez-vous que toutes les dépendances sont compatibles :
```bash
flutter pub outdated
```

## Causes possibles du crash

1. **Image manquante** : Le logo n'est pas trouvé → **Corrigé avec errorBuilder**
2. **Erreur non gérée** : Exception non capturée → **Corrigé avec gestion d'erreurs**
3. **Initialisation manquante** : WidgetsFlutterBinding non initialisé → **Corrigé**
4. **Problème de permissions** : Permissions iOS manquantes
5. **Problème de signature** : Certificat/provisioning profile invalide
6. **Dépendance incompatible** : Package incompatible avec iOS

## Comment déboguer

### Méthode 1 : Logs Xcode
1. Ouvrez Xcode
2. Window > Devices and Simulators
3. Sélectionnez votre iPhone
4. Cliquez sur "View Device Logs"
5. Cherchez les crash logs de votre app

### Méthode 2 : Console macOS
1. Ouvrez Console.app
2. Connectez votre iPhone
3. Filtrez par le nom de votre app "Khadma"
4. Regardez les erreurs au moment du crash

### Méthode 3 : Flutter en mode verbose
```bash
flutter run --release -v
```

## Si le problème persiste

1. **Testez en mode Debug** pour voir les erreurs détaillées
2. **Vérifiez les logs Xcode** pour les crash reports
3. **Vérifiez que tous les assets sont inclus** dans le build
4. **Testez sur un simulateur** pour isoler le problème
