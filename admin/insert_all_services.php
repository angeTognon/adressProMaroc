<?php
/**
 * Script pour insérer TOUS les services de l'application originale
 * Les services originaux : Plomberie, Électricité, Peinture, Menuiserie, Nettoyage, Jardinage, Chauffage, Climatisation
 */

require_once '../db.php';

try {
    echo "<h2>Insertion des services de l'application...</h2>\n";
    echo "<pre>\n";
    
    // Définir les services originaux de l'app
    $services = [
        [
            'id' => '1',
            'name' => 'Plomberie',
            'name_fr' => 'Plomberie',
            'icon' => '🔧',
            'description' => 'Réparation et installation de plomberie',
            'color' => '#2196F3',
            'is_active' => 1
        ],
        [
            'id' => '2',
            'name' => 'Électricité',
            'name_fr' => 'Électricité',
            'icon' => '⚡',
            'description' => 'Installation et réparation électrique',
            'color' => '#FFC107',
            'is_active' => 1
        ],
        [
            'id' => '3',
            'name' => 'Peinture',
            'name_fr' => 'Peinture',
            'icon' => '🎨',
            'description' => 'Peinture intérieure et extérieure',
            'color' => '#F44336',
            'is_active' => 1
        ],
        [
            'id' => '4',
            'name' => 'Menuiserie',
            'name_fr' => 'Menuiserie',
            'icon' => '🪚',
            'description' => 'Menuiserie et travaux sur mesure',
            'color' => '#795548',
            'is_active' => 1
        ],
        [
            'id' => '5',
            'name' => 'Nettoyage',
            'name_fr' => 'Nettoyage',
            'icon' => '🧹',
            'description' => 'Nettoyage professionnel',
            'color' => '#00BCD4',
            'is_active' => 1
        ],
        [
            'id' => '6',
            'name' => 'Jardinage',
            'name_fr' => 'Jardinage',
            'icon' => '🌳',
            'description' => 'Jardinage et entretien d\'espaces verts',
            'color' => '#4CAF50',
            'is_active' => 1
        ],
        [
            'id' => '7',
            'name' => 'Chauffage',
            'name_fr' => 'Chauffage',
            'icon' => '🔥',
            'description' => 'Installation et réparation de chauffage',
            'color' => '#FF5722',
            'is_active' => 1
        ],
        [
            'id' => '8',
            'name' => 'Climatisation',
            'name_fr' => 'Climatisation',
            'icon' => '❄️',
            'description' => 'Climatisation et ventilation',
            'color' => '#03A9F4',
            'is_active' => 1
        ]
    ];
    
    // Préparer la requête d'insertion avec gestion des doublons
    $stmt = $conn->prepare("
        INSERT INTO services (id, name, name_fr, icon, description, color, is_active)
        VALUES (:id, :name, :name_fr, :icon, :description, :color, :is_active)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            name_fr = VALUES(name_fr),
            icon = VALUES(icon),
            description = VALUES(description),
            color = VALUES(color),
            is_active = VALUES(is_active),
            updated_at = CURRENT_TIMESTAMP
    ");
    
    $insertedCount = 0;
    $updatedCount = 0;
    $errors = [];
    
    foreach ($services as $service) {
        try {
            $stmt->execute($service);
            
            // Vérifier si c'était une insertion ou une mise à jour
            $affectedRows = $stmt->rowCount();
            if ($affectedRows == 1 || $affectedRows == 2) {
                // Nouvelle insertion ou mise à jour
                if ($affectedRows == 1) {
                    $insertedCount++;
                    echo "✓ Service '{$service['name_fr']}' inséré (ID: {$service['id']})\n";
                } else {
                    $updatedCount++;
                    echo "↻ Service '{$service['name_fr']}' mis à jour (ID: {$service['id']})\n";
                }
            }
        } catch (PDOException $e) {
            $errors[] = "Erreur pour '{$service['name_fr']}': " . $e->getMessage();
            echo "✗ Erreur pour le service '{$service['name_fr']}': " . $e->getMessage() . "\n";
        }
    }
    
    echo "\n</pre>\n";
    echo "<h2 style='color: green;'>✓ Insertion terminée !</h2>\n";
    echo "<p><strong>Statistiques :</strong></p>\n";
    echo "<ul>\n";
    echo "  <li>Services insérés : <strong>$insertedCount</strong></li>\n";
    echo "  <li>Services mis à jour : <strong>$updatedCount</strong></li>\n";
    echo "  <li>Total traité : <strong>" . count($services) . "</strong></li>\n";
    if (!empty($errors)) {
        echo "  <li>Erreurs : <strong>" . count($errors) . "</strong></li>\n";
    }
    echo "</ul>\n";
    
    if (!empty($errors)) {
        echo "<h3 style='color: orange;'>Erreurs rencontrées :</h3>\n";
        echo "<ul>\n";
        foreach ($errors as $error) {
            echo "  <li>$error</li>\n";
        }
        echo "</ul>\n";
    }
    
    echo "<p><a href='admin.php' style='padding: 10px 20px; background: #C1272D; color: white; text-decoration: none; border-radius: 5px; display: inline-block; margin-top: 20px;'>Retour à l'administration</a></p>\n";
    
} catch(PDOException $e) {
    echo "<h2 style='color: red;'>Erreur lors de l'insertion</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
    echo "<p>Code d'erreur : " . $e->getCode() . "</p>\n";
}
?>
