# Correction de l'erreur d'installation

## Problème
Le build réussit mais l'installation/lancement échoue avec :
```
Could not run build/ios/iphoneos/Runner.app
Error running application on iPhone d'Ange (wireless).
```

## Solutions à essayer

### Solution 1 : Utiliser Xcode directement (Recommandé)

1. Ouvrez le projet dans Xcode :
```bash
open ios/Runner.xcworkspace
```

2. Dans Xcode :
   - Sélectionnez votre iPhone "iPhone d'Ange" comme destination (en haut)
   - Allez dans **Product > Run** (ou `Cmd + R`)
   - Xcode affichera des erreurs plus détaillées si le problème persiste

### Solution 2 : Essayer en mode Debug

Le mode debug est souvent plus permissif :
```bash
flutter run --debug -d 00008020-001E194426BA002E
```

### Solution 3 : Vérifier la signature dans Xcode

1. Ouvrez `ios/Runner.xcworkspace`
2. Sélectionnez le projet "Runner" dans le navigateur
3. Sélectionnez le target "Runner"
4. Allez dans l'onglet **"Signing & Capabilities"**
5. Vérifiez que :
   - ✅ "Automatically manage signing" est coché
   - ✅ Votre équipe est sélectionnée
   - ✅ Le Bundle Identifier est unique

### Solution 4 : Vérifier l'appareil

Sur votre iPhone :
1. **Réglages > Général > Gestion des appareils**
   - Vérifiez que votre profil de développeur est approuvé
   - Si l'app est déjà installée, supprimez-la

2. **Réglages > Confidentialité et sécurité > Mode développeur** (iOS 16+)
   - Activez le mode développeur si disponible

### Solution 5 : Nettoyer et reconstruire

```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter pub get
flutter run --release
```

### Solution 6 : Connecter via USB au lieu du sans fil

Parfois la connexion sans fil cause des problèmes :
1. Connectez votre iPhone via USB
2. Déverrouillez votre iPhone
3. Réessayez :
```bash
flutter run --release
```

### Solution 7 : Vérifier les logs Xcode

1. Ouvrez Xcode
2. **Window > Devices and Simulators**
3. Sélectionnez votre iPhone
4. Cliquez sur **"View Device Logs"**
5. Cherchez les erreurs au moment de l'installation

## Cause probable

En mode release avec connexion sans fil, il peut y avoir des problèmes de :
- Signature de code
- Provisioning profile
- Permissions de l'appareil
- Communication sans fil instable

**Recommandation** : Utilisez Xcode directement (`open ios/Runner.xcworkspace` puis `Cmd + R`) - c'est la méthode la plus fiable.
