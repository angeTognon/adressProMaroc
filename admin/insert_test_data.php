<?php
/**
 * Script pour insérer des données de test
 * Exécutez ce script une fois pour avoir des données dans votre admin
 */

require_once '../db.php';

try {
    echo "<h2>Insertion des données de test...</h2>\n";
    echo "<pre>\n";
    
    // Vérifier si des catégories existent déjà
    $checkCat = $conn->prepare("SELECT COUNT(*) as count FROM categories");
    $checkCat->execute();
    $catCount = $checkCat->fetch(PDO::FETCH_ASSOC)['count'];
    
    if ($catCount == 0) {
        echo "Insertion de catégories de test...\n";
        
        $categories = [
            [
                'id' => 'cat_1',
                'name' => 'Services de Réparation',
                'name_fr' => 'Services de Réparation',
                'icon' => '🔧',
                'description' => 'Tous les services de réparation et maintenance',
                'color' => '#2196F3'
            ],
            [
                'id' => 'cat_2',
                'name' => 'Services Domestiques',
                'name_fr' => 'Services Domestiques',
                'icon' => '🏠',
                'description' => 'Services pour la maison',
                'color' => '#4CAF50'
            ],
            [
                'id' => 'cat_3',
                'name' => 'Services Professionnels',
                'name_fr' => 'Services Professionnels',
                'icon' => '💼',
                'description' => 'Services professionnels et commerciaux',
                'color' => '#FF9800'
            ]
        ];
        
        $stmt = $conn->prepare("
            INSERT INTO categories (id, name, name_fr, icon, description, color)
            VALUES (:id, :name, :name_fr, :icon, :description, :color)
        ");
        
        foreach ($categories as $cat) {
            $stmt->execute($cat);
            echo "✓ Catégorie '{$cat['name_fr']}' insérée\n";
        }
    } else {
        echo "⚠ Des catégories existent déjà ($catCount catégories)\n";
    }
    
    // Vérifier si des services existent déjà
    $checkSrv = $conn->prepare("SELECT COUNT(*) as count FROM services");
    $checkSrv->execute();
    $srvCount = $checkSrv->fetch(PDO::FETCH_ASSOC)['count'];
    
    if ($srvCount == 0) {
        echo "\nInsertion de services de test...\n";
        
        $services = [
            [
                'id' => 'srv_1',
                'name' => 'Plomberie',
                'name_fr' => 'Plomberie',
                'category_id' => 'cat_1',
                'icon' => '🔧',
                'description' => 'Réparation et installation de plomberie',
                'color' => '#2196F3',
                'is_active' => 1
            ],
            [
                'id' => 'srv_2',
                'name' => 'Électricité',
                'name_fr' => 'Électricité',
                'category_id' => 'cat_1',
                'icon' => '⚡',
                'description' => 'Installation et réparation électrique',
                'color' => '#FFC107',
                'is_active' => 1
            ],
            [
                'id' => 'srv_3',
                'name' => 'Nettoyage',
                'name_fr' => 'Nettoyage',
                'category_id' => 'cat_2',
                'icon' => '🧹',
                'description' => 'Nettoyage professionnel',
                'color' => '#00BCD4',
                'is_active' => 1
            ]
        ];
        
        $stmt = $conn->prepare("
            INSERT INTO services (id, name, name_fr, category_id, icon, description, color, is_active)
            VALUES (:id, :name, :name_fr, :category_id, :icon, :description, :color, :is_active)
        ");
        
        foreach ($services as $srv) {
            $stmt->execute($srv);
            echo "✓ Service '{$srv['name_fr']}' inséré\n";
        }
    } else {
        echo "⚠ Des services existent déjà ($srvCount services)\n";
    }
    
    echo "\n</pre>\n";
    echo "<h2 style='color: green;'>✓ Données de test insérées avec succès !</h2>\n";
    echo "<p><a href='admin.php'>Retour à l'administration</a></p>\n";
    
} catch(PDOException $e) {
    echo "<h2 style='color: red;'>Erreur</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
}
?>
