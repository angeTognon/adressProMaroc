# Guide pour traiter le logo logo.png

## Objectif
Supprimer l'arrière-plan blanc et améliorer la qualité du logo pour une utilisation optimale dans l'application.

## Outils recommandés

### Option 1 : Remove.bg (Gratuit en ligne)
1. Allez sur https://www.remove.bg/
2. Uploadez `assets/logo.png`
3. Téléchargez le résultat (fond transparent)
4. Remplacez `assets/logo.png` par la nouvelle version

### Option 2 : Photopea (Gratuit, navigateur)
1. Allez sur https://www.photopea.com/
2. Ouvrez `assets/logo.png`
3. Utilisez l'outil "Magic Wand" pour sélectionner le fond blanc
4. Supprimez la sélection (Delete)
5. Exportez en PNG avec transparence
6. Remplacez le fichier original

### Option 3 : GIMP (Gratuit, desktop)
1. Ouvrez `assets/logo.png` dans GIMP
2. Outil "Sélection par couleur" → Cliquez sur le fond blanc
3. Supprimez (Delete)
4. Fichier → Exporter comme → PNG
5. Assurez-vous que "Enregistrer la couleur de fond" est coché

### Option 4 : Photoshop
1. Ouvrez `assets/logo.png`
2. Outil "Magic Wand" → Sélectionnez le fond blanc
3. Supprimez
4. Exportez en PNG avec transparence

## Amélioration de la qualité

### Pour augmenter la résolution :
1. Utilisez un outil d'upscaling IA :
   - https://www.upscale.media/ (gratuit)
   - https://imgupscaler.com/ (gratuit)
   - Waifu2x (pour images vectorielles)

2. Ou utilisez Photoshop/GIMP :
   - Image → Taille de l'image
   - Augmentez à 1024x1024px ou 2048x2048px
   - Utilisez l'interpolation "Bicubique plus nette" ou "Lanczos"

### Spécifications recommandées :
- **Format** : PNG avec transparence
- **Résolution** : Minimum 512x512px, idéalement 1024x1024px
- **Fond** : Transparent (pas de fond blanc)
- **Qualité** : Haute résolution pour éviter le flou

## Après traitement

Une fois le logo traité :
1. Remplacez `assets/logo.png` par la nouvelle version
2. Le logo sera automatiquement utilisé dans :
   - Splash screen
   - Tous les endroits où il est référencé

## Vérification

Après avoir remplacé le logo, testez dans l'application :
- Le logo s'affiche correctement dans le splash screen
- Le fond est transparent (pas de carré blanc)
- La qualité est bonne à toutes les tailles
