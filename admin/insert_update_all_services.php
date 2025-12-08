<?php
/**
 * Script pour ajouter/mettre à jour tous les services
 * Basé sur la liste des services du dropdown
 * 
 * Usage: Accéder à cette page via navigateur ou exécuter via CLI
 */

require_once '../db.php';

// Liste complète des services avec leurs emojis et couleurs
$services = [
    ['name' => 'Plomberie', 'name_fr' => 'Plomberie', 'icon' => '🔧', 'color' => '#2196F3', 'description' => 'Réparation et installation de plomberie'],
    ['name' => 'Electricité', 'name_fr' => 'Électricité', 'icon' => '⚡', 'color' => '#FFC107', 'description' => 'Installation et réparation électrique'],
    ['name' => 'Menuiserie', 'name_fr' => 'Menuiserie', 'icon' => '🪚', 'color' => '#795548', 'description' => 'Menuiserie et travaux sur mesure'],
    ['name' => 'Électronique', 'name_fr' => 'Électronique', 'icon' => '🔌', 'color' => '#9C27B0', 'description' => 'Réparation et installation électronique'],
    ['name' => 'Maçonnerie', 'name_fr' => 'Maçonnerie', 'icon' => '🧱', 'color' => '#607D8B', 'description' => 'Travaux de maçonnerie et construction'],
    ['name' => 'Peinture', 'name_fr' => 'Peinture', 'icon' => '🎨', 'color' => '#F44336', 'description' => 'Peinture intérieure et extérieure'],
    ['name' => 'Parabole', 'name_fr' => 'Parabole', 'icon' => '📡', 'color' => '#009688', 'description' => 'Installation et réparation de paraboles'],
    ['name' => 'Vitrerie - Aluminium', 'name_fr' => 'Vitrerie - Aluminium', 'icon' => '🪟', 'color' => '#00BCD4', 'description' => 'Vitrerie et travaux en aluminium'],
    ['name' => 'Clim et froid', 'name_fr' => 'Climatisation et froid', 'icon' => '❄️', 'color' => '#03A9F4', 'description' => 'Installation et réparation de climatisation'],
    ['name' => 'Serrurerie', 'name_fr' => 'Serrurerie', 'icon' => '🔐', 'color' => '#8BC34A', 'description' => 'Services de serrurerie'],
    ['name' => 'Plâtrier', 'name_fr' => 'Plâtrier', 'icon' => '🧹', 'color' => '#FF9800', 'description' => 'Travaux de plâtrerie'],
    ['name' => 'Ferronnerie', 'name_fr' => 'Ferronnerie', 'icon' => '⚙️', 'color' => '#9E9E9E', 'description' => 'Travaux de ferronnerie'],
    ['name' => 'Surveillance et alarmes', 'name_fr' => 'Surveillance et alarmes', 'icon' => '🚨', 'color' => '#E91E63', 'description' => 'Installation de systèmes de surveillance'],
    ['name' => 'Etanchéité', 'name_fr' => 'Étanchéité', 'icon' => '💧', 'color' => '#00ACC1', 'description' => 'Travaux d\'étanchéité'],
    ['name' => 'Carrelage', 'name_fr' => 'Carrelage', 'icon' => '🧱', 'color' => '#FF5722', 'description' => 'Pose et réparation de carrelage'],
    ['name' => 'Electro - ménager', 'name_fr' => 'Électroménager', 'icon' => '🏠', 'color' => '#FF6F00', 'description' => 'Réparation d\'électroménager'],
    ['name' => 'Mécanique', 'name_fr' => 'Mécanique', 'icon' => '🔧', 'color' => '#424242', 'description' => 'Services de mécanique automobile'],
    ['name' => 'Transport', 'name_fr' => 'Transport', 'icon' => '🚚', 'color' => '#1976D2', 'description' => 'Services de transport'],
    ['name' => 'Electricité-Auto', 'name_fr' => 'Électricité Auto', 'icon' => '🔋', 'color' => '#7B1FA2', 'description' => 'Électricité automobile'],
    ['name' => 'Tapisserie', 'name_fr' => 'Tapisserie', 'icon' => '🛋️', 'color' => '#C2185B', 'description' => 'Services de tapisserie'],
    ['name' => 'Ascenseurs', 'name_fr' => 'Ascenseurs', 'icon' => '⬆️', 'color' => '#5D4037', 'description' => 'Installation et maintenance d\'ascenseurs'],
    ['name' => 'Jardinier', 'name_fr' => 'Jardinier', 'icon' => '🌳', 'color' => '#4CAF50', 'description' => 'Jardinage et entretien d\'espaces verts'],
    ['name' => 'Démolition', 'name_fr' => 'Démolition', 'icon' => '🏗️', 'color' => '#616161', 'description' => 'Services de démolition'],
    ['name' => 'Encadrement', 'name_fr' => 'Encadrement', 'icon' => '🖼️', 'color' => '#795548', 'description' => 'Services d\'encadrement'],
    ['name' => 'Pneumatiques', 'name_fr' => 'Pneumatiques', 'icon' => '🛞', 'color' => '#212121', 'description' => 'Vente et réparation de pneumatiques'],
    ['name' => 'Marbre', 'name_fr' => 'Marbre', 'icon' => '💎', 'color' => '#BDBDBD', 'description' => 'Travaux en marbre'],
    ['name' => 'Dépannage', 'name_fr' => 'Dépannage', 'icon' => '🆘', 'color' => '#D32F2F', 'description' => 'Services de dépannage divers'],
    ['name' => 'Piscine', 'name_fr' => 'Piscine', 'icon' => '🏊', 'color' => '#0288D1', 'description' => 'Installation et maintenance de piscines'],
];

try {
    echo "<h2>Ajout/Mise à jour des services</h2>\n";
    echo "<pre>\n";
    
    $conn->beginTransaction();
    
    $inserted = 0;
    $updated = 0;
    $errors = [];
    
    foreach ($services as $service) {
        try {
            // Vérifier si le service existe déjà
            $checkStmt = $conn->prepare("
                SELECT id FROM services 
                WHERE name = :name OR name_fr = :name_fr 
                LIMIT 1
            ");
            $checkStmt->execute([
                ':name' => $service['name'],
                ':name_fr' => $service['name_fr']
            ]);
            $existing = $checkStmt->fetch(PDO::FETCH_ASSOC);
            
            if ($existing) {
                // Mettre à jour le service existant
                $updateStmt = $conn->prepare("
                    UPDATE services 
                    SET name = :name, 
                        name_fr = :name_fr, 
                        icon = :icon, 
                        color = :color, 
                        description = :description,
                        is_active = 1
                    WHERE id = :id
                ");
                
                $updateStmt->execute([
                    ':id' => $existing['id'],
                    ':name' => $service['name'],
                    ':name_fr' => $service['name_fr'],
                    ':icon' => $service['icon'],
                    ':color' => $service['color'],
                    ':description' => $service['description'],
                ]);
                
                $updated++;
                echo "✓ Mis à jour: {$service['name_fr']}\n";
                
            } else {
                // Insérer un nouveau service
                $serviceId = 'service_' . strtolower(str_replace([' ', '-', 'é', 'è'], '', $service['name'])) . '_' . uniqid();
                
                $insertStmt = $conn->prepare("
                    INSERT INTO services (
                        id, name, name_fr, icon, color, description, is_active
                    ) VALUES (
                        :id, :name, :name_fr, :icon, :color, :description, 1
                    )
                ");
                
                $insertStmt->execute([
                    ':id' => $serviceId,
                    ':name' => $service['name'],
                    ':name_fr' => $service['name_fr'],
                    ':icon' => $service['icon'],
                    ':color' => $service['color'],
                    ':description' => $service['description'],
                ]);
                
                $inserted++;
                echo "✓ Ajouté: {$service['name_fr']}\n";
            }
            
        } catch (PDOException $e) {
            $errors[] = "Erreur pour {$service['name_fr']}: " . $e->getMessage();
            echo "✗ Erreur pour {$service['name_fr']}: " . $e->getMessage() . "\n";
        }
    }
    
    $conn->commit();
    
    echo "\n";
    echo "=== RÉSULTAT ===\n";
    echo "Services ajoutés: $inserted\n";
    echo "Services mis à jour: $updated\n";
    echo "Erreurs: " . count($errors) . "\n";
    
    if (!empty($errors)) {
        echo "\n=== ERREURS ===\n";
        foreach ($errors as $error) {
            echo "- $error\n";
        }
    }
    
    echo "\n✓ Tous les services ont été ajoutés/mis à jour dans la base de données.\n";
    echo "</pre>\n";
    
} catch (Exception $e) {
    $conn->rollBack();
    echo "<h2 style='color: red;'>Erreur</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
}
?>
