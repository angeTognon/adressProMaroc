<?php
/**
 * Script d'insertion des services dans la base de données
 * 
 * Ce script insère les services présents dans l'application Flutter
 * dans la table 'services' de la base de données
 * 
 * Exécution : Accédez à ce fichier via votre navigateur ou en ligne de commande
 */

require_once 'db.php';

try {
    echo "<h2>Insertion des services en cours...</h2>\n";
    echo "<pre>\n";
    
    // Vérifier si les services existent déjà
    $checkStmt = $conn->prepare("SELECT COUNT(*) as count FROM services");
    $checkStmt->execute();
    $result = $checkStmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result['count'] > 0) {
        echo "⚠ Des services existent déjà dans la base de données.\n";
        echo "Voulez-vous vider la table et réinsérer ? (Modifiez ce script pour le faire automatiquement)\n\n";
        // Décommenter les lignes suivantes pour vider et réinsérer
        // $conn->exec("DELETE FROM services");
        // echo "✓ Table 'services' vidée\n\n";
    }
    
    // Définir les services à insérer (basés sur mock_data.dart)
    $services = [
        [
            'id' => '',
            'name' => 'Test2',
            'name_fr' => 'Test2',
            'icon' => '❤️‍🔥',
            'description' => 'Test2 Description',
            'color' => '#03A9F4'
        ]
    ];
    
    // Préparer la requête d'insertion avec gestion des doublons
    $stmt = $conn->prepare("
        INSERT INTO services (id, name, name_fr, icon, description, color, is_active)
        VALUES (:id, :name, :name_fr, :icon, :description, :color, 1)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            name_fr = VALUES(name_fr),
            icon = VALUES(icon),
            description = VALUES(description),
            color = VALUES(color),
            updated_at = CURRENT_TIMESTAMP
    ");
    
    $insertedCount = 0;
    $updatedCount = 0;
    
    foreach ($services as $service) {
        try {
            $stmt->execute([
                ':id' => $service['id'],
                ':name' => $service['name'],
                ':name_fr' => $service['name_fr'],
                ':icon' => $service['icon'],
                ':description' => $service['description'],
                ':color' => $service['color']
            ]);
            
            // Vérifier si c'était une insertion ou une mise à jour
            $affectedRows = $stmt->rowCount();
            if ($affectedRows == 1) {
                // Nouvelle insertion
                $insertedCount++;
                echo "✓ Service '{$service['name']}' inséré (ID: {$service['id']})\n";
            } else {
                // Mise à jour
                $updatedCount++;
                echo "↻ Service '{$service['name']}' mis à jour (ID: {$service['id']})\n";
            }
        } catch (PDOException $e) {
            echo "✗ Erreur pour le service '{$service['name']}': " . $e->getMessage() . "\n";
        }
    }
    
    echo "</pre>\n";
    echo "<h2 style='color: green;'>✓ Insertion terminée !</h2>\n";
    echo "<p><strong>Statistiques :</strong></p>\n";
    echo "<ul>\n";
    echo "  <li>Services insérés : <strong>$insertedCount</strong></li>\n";
    echo "  <li>Services mis à jour : <strong>$updatedCount</strong></li>\n";
    echo "  <li>Total : <strong>" . count($services) . "</strong></li>\n";
    echo "</ul>\n";
    
} catch(PDOException $e) {
    echo "<h2 style='color: red;'>Erreur lors de l'insertion</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
    echo "<p>Code d'erreur : " . $e->getCode() . "</p>\n";
}
?>
