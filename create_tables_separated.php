<?php
/**
 * Script de création des tables avec PROFESSIONALS et USERS séparés
 * 
 * - users : Utilisateurs/visiteurs classiques (clients)
 * - professionals : Professionnels indépendants (avec leur propre authentification)
 */

require_once 'db.php';

try {
    // Commencer une transaction
    $conn->beginTransaction();
    
    echo "<h2>Création des tables (structure séparée)...</h2>\n";
    echo "<pre>\n";
    
    // ==========================================
    // 1. Table SERVICES
    // ==========================================
    echo "1. Création de la table 'services'...\n";
    $sql_services = "CREATE TABLE IF NOT EXISTS services (
        id VARCHAR(50) PRIMARY KEY,
        category_id VARCHAR(50) DEFAULT NULL,
        name VARCHAR(100) NOT NULL,
        name_fr VARCHAR(100) NOT NULL,
        name_ar VARCHAR(100) DEFAULT NULL,
        name_darija VARCHAR(100) DEFAULT NULL,
        icon VARCHAR(10) DEFAULT NULL,
        description TEXT DEFAULT NULL,
        color VARCHAR(7) DEFAULT '#2196F3',
        is_active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_category (category_id),
        INDEX idx_name (name),
        INDEX idx_active (is_active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    
    $conn->exec($sql_services);
    echo "   ✓ Table 'services' créée avec succès\n\n";
    
    // ==========================================
    // 2. Table USERS (Utilisateurs/Visiteurs - Clients)
    // ==========================================
    echo "2. Création de la table 'users' (clients/visiteurs)...\n";
    $sql_users = "CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(50) PRIMARY KEY,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        phone VARCHAR(20) DEFAULT NULL,
        profile_image VARCHAR(500) DEFAULT NULL,
        is_guest BOOLEAN DEFAULT FALSE,
        is_active BOOLEAN DEFAULT TRUE,
        email_verified_at TIMESTAMP NULL DEFAULT NULL,
        remember_token VARCHAR(100) DEFAULT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_email (email),
        INDEX idx_phone (phone),
        INDEX idx_active (is_active)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    
    $conn->exec($sql_users);
    echo "   ✓ Table 'users' créée avec succès\n\n";
    
    // ==========================================
    // 3. Table PROFESSIONALS (Professionnels - Indépendants)
    // ==========================================
    echo "3. Création de la table 'professionals' (indépendante)...\n";
    $sql_professionals = "CREATE TABLE IF NOT EXISTS professionals (
        id VARCHAR(50) PRIMARY KEY,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        phone VARCHAR(20) NOT NULL,
        business_name VARCHAR(200) DEFAULT NULL,
        service_id VARCHAR(50) DEFAULT NULL COMMENT 'Service principal',
        city VARCHAR(100) NOT NULL,
        district VARCHAR(100) DEFAULT NULL,
        address TEXT NOT NULL,
        location VARCHAR(255) NOT NULL COMMENT 'Format: district, city',
        description TEXT DEFAULT NULL,
        base_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
        certification_number VARCHAR(100) DEFAULT NULL,
        tax_id VARCHAR(100) DEFAULT NULL,
        profile_image VARCHAR(500) DEFAULT NULL,
        status ENUM('pending', 'verified', 'rejected', 'suspended') DEFAULT 'pending',
        rejection_reason TEXT DEFAULT NULL,
        is_available BOOLEAN DEFAULT TRUE,
        rating DECIMAL(3, 2) DEFAULT 0.00,
        reviews_count INT DEFAULT 0,
        email_verified_at TIMESTAMP NULL DEFAULT NULL,
        verified_at TIMESTAMP NULL DEFAULT NULL,
        remember_token VARCHAR(100) DEFAULT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE SET NULL ON UPDATE CASCADE,
        INDEX idx_email (email),
        INDEX idx_phone (phone),
        INDEX idx_service (service_id),
        INDEX idx_city (city),
        INDEX idx_district (district),
        INDEX idx_status (status),
        INDEX idx_available (is_available),
        INDEX idx_rating (rating)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    
    $conn->exec($sql_professionals);
    echo "   ✓ Table 'professionals' créée avec succès\n\n";
    
    // ==========================================
    // 4. Table PROFESSIONAL_SERVICES (Table de liaison)
    // ==========================================
    echo "4. Création de la table 'professional_services'...\n";
    $sql_professional_services = "CREATE TABLE IF NOT EXISTS professional_services (
        id INT AUTO_INCREMENT PRIMARY KEY,
        professional_id VARCHAR(50) NOT NULL,
        service_id VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY unique_professional_service (professional_id, service_id),
        FOREIGN KEY (professional_id) REFERENCES professionals(id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE ON UPDATE CASCADE,
        INDEX idx_professional (professional_id),
        INDEX idx_service (service_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    
    $conn->exec($sql_professional_services);
    echo "   ✓ Table 'professional_services' créée avec succès\n\n";
    
    // ==========================================
    // 5. Table PROFESSIONAL_DOCUMENTS
    // ==========================================
    echo "5. Création de la table 'professional_documents'...\n";
    $sql_professional_documents = "CREATE TABLE IF NOT EXISTS professional_documents (
        id INT AUTO_INCREMENT PRIMARY KEY,
        professional_id VARCHAR(50) NOT NULL,
        document_type VARCHAR(50) NOT NULL COMMENT 'CNI, certificat, etc.',
        document_url VARCHAR(500) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (professional_id) REFERENCES professionals(id) ON DELETE CASCADE ON UPDATE CASCADE,
        INDEX idx_professional (professional_id),
        INDEX idx_type (document_type)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;";
    
    $conn->exec($sql_professional_documents);
    echo "   ✓ Table 'professional_documents' créée avec succès\n\n";
    
    // Valider la transaction
    $conn->commit();
    
    echo "</pre>\n";
    echo "<h2 style='color: green;'>✓ Toutes les tables ont été créées avec succès !</h2>\n";
    echo "<p><strong>Structure :</strong></p>\n";
    echo "<ul>\n";
    echo "  <li><strong>services</strong> - Services disponibles</li>\n";
    echo "  <li><strong>users</strong> - Utilisateurs/Visiteurs (clients classiques)</li>\n";
    echo "  <li><strong>professionals</strong> - Professionnels (indépendants avec authentification propre)</li>\n";
    echo "  <li><strong>professional_services</strong> - Relation entre professionnels et services</li>\n";
    echo "  <li><strong>professional_documents</strong> - Documents des professionnels</li>\n";
    echo "</ul>\n";
    echo "<p style='color: #2196F3;'><strong>Note :</strong> Les tables 'users' et 'professionals' sont maintenant complètement séparées et indépendantes.</p>\n";
    
} catch(PDOException $e) {
    // En cas d'erreur, annuler la transaction
    $conn->rollBack();
    echo "<h2 style='color: red;'>Erreur lors de la création des tables</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
    echo "<p>Code d'erreur : " . $e->getCode() . "</p>\n";
}
?>
