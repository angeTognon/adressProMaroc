<?php
/**
 * Script de migration pour séparer professionals et users
 * 
 * Ce script :
 * 1. Crée une nouvelle structure où professionals est indépendant
 * 2. Migre les données existantes si besoin
 * 3. Supprime l'ancienne clé étrangère user_id
 */

require_once 'db.php';

try {
    echo "<h2>Migration vers structure séparée...</h2>\n";
    echo "<pre>\n";
    
    $conn->beginTransaction();
    
    // Vérifier si la colonne user_id existe encore
    $checkColumn = $conn->query("SHOW COLUMNS FROM professionals LIKE 'user_id'");
    $hasUserId = $checkColumn->rowCount() > 0;
    
    if ($hasUserId) {
        echo "1. Migration des données...\n";
        
        // Récupérer tous les professionnels avec leurs user_id
        $stmt = $conn->query("SELECT p.*, u.email as user_email, u.password as user_password, u.first_name as user_first_name, u.last_name as user_last_name, u.phone as user_phone FROM professionals p LEFT JOIN users u ON p.user_id = u.id");
        $professionals = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo "   Trouvé " . count($professionals) . " professionnels à migrer\n";
        
        // Ajouter les colonnes d'authentification si elles n'existent pas
        $checkEmail = $conn->query("SHOW COLUMNS FROM professionals LIKE 'email'");
        if ($checkEmail->rowCount() == 0) {
            echo "2. Ajout des colonnes d'authentification...\n";
            $conn->exec("ALTER TABLE professionals 
                ADD COLUMN email VARCHAR(255) NULL AFTER id,
                ADD COLUMN password VARCHAR(255) NULL AFTER email,
                ADD COLUMN first_name VARCHAR(100) NULL AFTER password,
                ADD COLUMN last_name VARCHAR(100) NULL AFTER first_name");
            
            // Migrer les données depuis users
            foreach ($professionals as $pro) {
                if (!empty($pro['user_id']) && !empty($pro['user_email'])) {
                    $updateStmt = $conn->prepare("
                        UPDATE professionals 
                        SET email = :email,
                            password = :password,
                            first_name = :first_name,
                            last_name = :last_name
                        WHERE id = :id
                    ");
                    $updateStmt->execute([
                        ':email' => $pro['user_email'],
                        ':password' => $pro['user_password'] ?? '',
                        ':first_name' => $pro['user_first_name'] ?? '',
                        ':last_name' => $pro['user_last_name'] ?? '',
                        ':id' => $pro['id']
                    ]);
                    echo "   ✓ Professionnel '{$pro['id']}' migré\n";
                }
            }
            
            // Rendre les colonnes NOT NULL après migration
            echo "3. Finalisation des colonnes...\n";
            $conn->exec("ALTER TABLE professionals 
                MODIFY COLUMN email VARCHAR(255) NOT NULL,
                MODIFY COLUMN password VARCHAR(255) NOT NULL,
                MODIFY COLUMN first_name VARCHAR(100) NOT NULL,
                MODIFY COLUMN last_name VARCHAR(100) NOT NULL");
            
            echo "   ✓ Colonnes finalisées\n";
        }
        
        // Ajouter index unique sur email
        try {
            $conn->exec("ALTER TABLE professionals ADD UNIQUE KEY idx_email_unique (email)");
            echo "   ✓ Index unique sur email ajouté\n";
        } catch (PDOException $e) {
            if (strpos($e->getMessage(), 'Duplicate key') === false) {
                throw $e;
            }
            echo "   ⚠ Index email déjà présent\n";
        }
        
        // Supprimer la clé étrangère user_id
        echo "4. Suppression de la dépendance user_id...\n";
        try {
            $conn->exec("ALTER TABLE professionals DROP FOREIGN KEY professionals_ibfk_1");
            echo "   ✓ Clé étrangère supprimée\n";
        } catch (PDOException $e) {
            echo "   ⚠ Clé étrangère non trouvée (peut-être déjà supprimée)\n";
        }
        
        // Supprimer la colonne user_id
        echo "5. Suppression de la colonne user_id...\n";
        try {
            $conn->exec("ALTER TABLE professionals DROP COLUMN user_id");
            echo "   ✓ Colonne user_id supprimée\n";
        } catch (PDOException $e) {
            echo "   ⚠ Colonne user_id non trouvée (peut-être déjà supprimée)\n";
        }
        
    } else {
        echo "✓ La table professionals est déjà indépendante (pas de user_id)\n";
    }
    
    $conn->commit();
    
    echo "\n</pre>\n";
    echo "<h2 style='color: green;'>✓ Migration terminée avec succès !</h2>\n";
    echo "<p>Les tables sont maintenant complètement séparées :</p>\n";
    echo "<ul>\n";
    echo "  <li><strong>users</strong> - Clients/Visiteurs (authentification indépendante)</li>\n";
    echo "  <li><strong>professionals</strong> - Professionnels (authentification indépendante)</li>\n";
    echo "</ul>\n";
    
} catch(PDOException $e) {
    $conn->rollBack();
    echo "<h2 style='color: red;'>Erreur lors de la migration</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
}
?>
