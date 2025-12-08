# Guide d'installation sur iPhone physique

## Méthode 1 : Flutter install (Recommandée)

### Étape 1 : Connecter votre iPhone
- Connectez votre iPhone à votre Mac via USB
- Déverrouillez votre iPhone et approuvez la connexion si demandé

### Étape 2 : Vérifier la connexion
```bash
flutter devices
```
Vous devriez voir votre iPhone dans la liste.

### Étape 3 : Installer directement
```bash
# Installer en mode release
flutter install --release

# Ou spécifier l'ID de votre iPhone
flutter install --release -d [ID_DE_VOTRE_IPHONE]
```

## Méthode 2 : Flutter run (Installe et lance)

```bash
# En mode release
flutter run --release

# Sélectionnez votre iPhone dans la liste
```

## Méthode 3 : Via Xcode (Plus de contrôle)

### Étape 1 : Ouvrir le projet dans Xcode
```bash
open ios/Runner.xcworkspace
```

### Étape 2 : Configurer la signature
1. Dans Xcode, sélectionnez le projet "Runner" dans le navigateur
2. Sélectionnez le target "Runner"
3. Allez dans l'onglet "Signing & Capabilities"
4. Cochez "Automatically manage signing"
5. Sélectionnez votre équipe de développement

### Étape 3 : Sélectionner votre iPhone
1. En haut de Xcode, cliquez sur le menu déroulant à côté de "Runner"
2. Sélectionnez votre iPhone dans la liste des appareils

### Étape 4 : Installer
1. Cliquez sur le bouton "Play" (▶️) ou appuyez sur `Cmd + R`
2. Xcode va compiler et installer l'app sur votre iPhone

## Méthode 4 : Créer une Archive (Pour distribution)

### Étape 1 : Créer l'archive
1. Dans Xcode, allez dans **Product > Archive**
2. Attendez que l'archive soit créée

### Étape 2 : Installer depuis l'archive
1. Une fois l'archive créée, la fenêtre "Organizer" s'ouvre
2. Sélectionnez votre archive
3. Cliquez sur "Distribute App"
4. Choisissez "Development" ou "Ad Hoc"
5. Sélectionnez votre iPhone
6. Suivez les instructions

## Méthode 5 : Utiliser ios-deploy (Alternative)

### Installation de ios-deploy
```bash
npm install -g ios-deploy
```

### Installation de l'app
```bash
ios-deploy --bundle build/ios/iphoneos/Runner.app
```

## Vérifications importantes

### 1. Vérifier que votre iPhone est approuvé
Sur votre iPhone :
- **Réglages > Général > Gestion des appareils**
- Vérifiez que votre profil de développeur est approuvé

### 2. Vérifier le mode développeur (iOS 16+)
Sur votre iPhone :
- **Réglages > Confidentialité et sécurité > Mode développeur**
- Activez le mode développeur si disponible

### 3. Vérifier la connexion
```bash
# Voir tous les appareils connectés
flutter devices

# Voir les appareils iOS spécifiquement
xcrun xctrace list devices
```

## Dépannage

### "No devices found"
- Vérifiez que votre iPhone est connecté via USB
- Déverrouillez votre iPhone
- Approuvez la connexion sur l'iPhone si demandé
- Essayez de débrancher et rebrancher le câble

### "Could not install"
- Vérifiez que votre iPhone est approuvé dans Réglages
- Vérifiez que le mode développeur est activé (iOS 16+)
- Vérifiez la signature dans Xcode

### "Untrusted Developer"
Sur votre iPhone :
- **Réglages > Général > Gestion des appareils**
- Trouvez votre profil de développeur
- Appuyez sur "Approuver"

## Commandes rapides

```bash
# Voir les appareils disponibles
flutter devices

# Installer en release
flutter install --release

# Installer et lancer en release
flutter run --release

# Installer sur un appareil spécifique
flutter install --release -d 00008020-001E194426BA002E
```
