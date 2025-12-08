# Guide de dépannage - Déploiement iOS

## Problème rencontré
Le build Xcode réussit mais l'application ne peut pas être lancée sur l'iPhone en mode release.

## Solutions à essayer

### 1. Essayer en mode Debug d'abord
```bash
flutter run --debug
```
Le mode debug utilise généralement une signature automatique plus permissive.

### 2. Vérifier la signature dans Xcode
1. Ouvrez le projet dans Xcode :
```bash
open ios/Runner.xcworkspace
```

2. Sélectionnez le target "Runner" dans le navigateur de projet
3. Allez dans l'onglet "Signing & Capabilities"
4. Vérifiez que :
   - "Automatically manage signing" est coché
   - Votre équipe de développement est sélectionnée
   - Le Bundle Identifier est unique (actuellement : `com.example.adressPro`)

### 3. Changer le Bundle Identifier
Le Bundle Identifier `com.example.adressPro` peut causer des problèmes. Changez-le pour quelque chose d'unique :
- Format recommandé : `com.votrenom.khadma` ou `ma.khadma.app`

### 4. Vérifier que l'appareil est configuré
Sur votre iPhone :
1. Allez dans **Réglages > Général > Gestion des appareils**
2. Vérifiez que votre profil de développeur est approuvé
3. Si l'app est installée, supprimez-la et réessayez

### 5. Vérifier les logs détaillés
```bash
flutter run --release -v
```
L'option `-v` (verbose) affichera plus de détails sur l'erreur.

### 6. Nettoyer et reconstruire
```bash
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter pub get
flutter run --release
```

### 7. Vérifier les certificats
```bash
security find-identity -v -p codesigning
```
Cela liste tous vos certificats de signature disponibles.

### 8. Essayer avec Xcode directement
1. Ouvrez `ios/Runner.xcworkspace` dans Xcode
2. Sélectionnez votre iPhone comme destination
3. Cliquez sur "Product > Run" (ou Cmd+R)
4. Xcode affichera des erreurs plus détaillées si le problème persiste

## Solutions alternatives

### Option A : Utiliser le mode Debug pour les tests
Pour les tests, utilisez le mode debug qui est plus permissif :
```bash
flutter run --debug
```

### Option B : Créer un Archive dans Xcode
1. Ouvrez Xcode
2. Product > Archive
3. Une fois l'archive créée, vous pouvez la distribuer via TestFlight ou l'installer directement

### Option C : Vérifier les permissions
Assurez-vous que votre iPhone autorise les apps de développeurs :
- Réglages > Confidentialité et sécurité > Mode développeur (si disponible)

## Problèmes courants

### "Could not run build/ios/iphoneos/Runner.app"
- **Cause** : Problème de signature ou provisioning profile
- **Solution** : Vérifier la signature dans Xcode, s'assurer que l'appareil est approuvé

### "Developer Mode is not enabled"
- **Cause** : Le mode développeur n'est pas activé sur l'iPhone
- **Solution** : Activer dans Réglages > Confidentialité et sécurité > Mode développeur

### "Untrusted Developer"
- **Cause** : Le profil de développeur n'est pas approuvé
- **Solution** : Réglages > Général > Gestion des appareils > Approuver le développeur
