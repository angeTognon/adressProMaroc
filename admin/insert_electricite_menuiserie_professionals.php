<?php
/**
 * Script pour insérer les professionnels d'électricité et de menuiserie
 * 
 * Usage: Accéder à cette page via navigateur ou exécuter via CLI
 */

require_once '../db.php';

// Données des professionnels d'électricité
$electriciteProfessionals = [
    ['nom' => 'GROGRI Simohamed', 'phone' => '06 69 46 96 91', 'city' => 'Kenitra', 'district' => 'la ville haute'],
    ['nom' => 'BOUGRIR Mustapha', 'phone' => '06 39 07 28 37', 'city' => 'Kenitra', 'district' => 'la ville haute'],
    ['nom' => 'AMZOUZ Simohamed', 'phone' => '06 63 25 17 54', 'city' => 'Casablanca', 'district' => 'Avenue Bordeaux'],
    ['nom' => 'EL MOAL Khalid', 'phone' => '06 65 61 03 37', 'city' => 'Casablanca', 'district' => 'Bourgogne'],
    ['nom' => 'MOUATASSIM Zakariae', 'phone' => '06 73 74 30 95', 'city' => 'Salé', 'district' => 'Tabriquet'],
    ['nom' => 'BAKELLA Ibrahim', 'phone' => '06 65 64 95 84', 'city' => 'Salé', 'district' => null],
    ['nom' => 'ELWADI Hassan', 'phone' => '06 13 65 36 92', 'city' => 'Rabat', 'district' => null],
    ['nom' => 'ELWARZAZI Omar', 'phone' => '06 62 45 79 39', 'city' => 'Rabat', 'district' => null],
];

// Données des professionnels de menuiserie
$menuiserieProfessionals = [
    ['nom' => 'ELHADI Otman', 'phone' => '06 18 46 23 35', 'city' => 'Fès', 'district' => null],
    ['nom' => 'HMOURMI Mohammed', 'phone' => '06 64 86 41 66', 'city' => 'Fès', 'district' => null],
    ['nom' => 'ELMAHZOUM Mohammed', 'phone' => '06 49 93 55 36', 'city' => 'Fès', 'district' => null],
    ['nom' => 'SBAAI Abdel Monaim', 'phone' => '06 26 20 87 50', 'city' => 'Salé', 'district' => 'Hay Rahma'],
    ['nom' => 'RAHLI Boujamaa', 'phone' => '06 65 83 58 68', 'city' => 'Salé', 'district' => 'Hay Essalam'],
    ['nom' => 'AKRIS Mustapha', 'phone' => '06 42 75 63 57', 'city' => 'Casablanca', 'district' => null],
    ['nom' => 'SANIE Fouad', 'phone' => '06 67 75 87 03', 'city' => 'Casablanca', 'district' => 'Sidi Bernoussi'],
    ['nom' => 'LABID Hicham', 'phone' => '06 74 41 00 11', 'city' => 'Casablanca', 'district' => 'Sidi Moumen'],
];

try {
    // Trouver l'ID du service Électricité
    $electriciteServiceStmt = $conn->prepare("SELECT id FROM services WHERE name_fr LIKE '%Electricité%' OR name LIKE '%Electricité%' OR name LIKE '%Électricité%' OR name LIKE '%Electricity%' LIMIT 1");
    $electriciteServiceStmt->execute();
    $electriciteService = $electriciteServiceStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$electriciteService) {
        throw new Exception("Service Électricité non trouvé dans la base de données. Veuillez d'abord créer ce service.");
    }
    
    $electriciteServiceId = $electriciteService['id'];
    
    // Trouver l'ID du service Menuiserie
    $menuiserieServiceStmt = $conn->prepare("SELECT id FROM services WHERE name_fr LIKE '%Menuiserie%' OR name LIKE '%Menuiserie%' OR name LIKE '%Carpentry%' LIMIT 1");
    $menuiserieServiceStmt->execute();
    $menuiserieService = $menuiserieServiceStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$menuiserieService) {
        throw new Exception("Service Menuiserie non trouvé dans la base de données. Veuillez d'abord créer ce service.");
    }
    
    $menuiserieServiceId = $menuiserieService['id'];
    
    echo "<h2>Insertion des professionnels d'électricité et de menuiserie</h2>\n";
    echo "<pre>\n";
    echo "Service Électricité trouvé: ID = $electriciteServiceId\n";
    echo "Service Menuiserie trouvé: ID = $menuiserieServiceId\n\n";
    
    $conn->beginTransaction();
    
    $inserted = 0;
    $errors = [];
    
    // Fonction pour insérer un professionnel
    function insertProfessional($conn, $pro, $serviceId, $serviceName, $index, &$inserted, &$errors) {
        try {
            // Extraire prénom et nom
            $nameParts = explode(' ', trim($pro['nom']), 2);
            $firstName = $nameParts[0] ?? '';
            $lastName = isset($nameParts[1]) ? $nameParts[1] : '';
            
            // Si pas de nom de famille, utiliser le prénom
            if (empty($lastName)) {
                $lastName = $firstName;
                $firstName = '';
            }
            
            // Générer un email unique
            $emailBase = strtolower(str_replace([' ', '-', "'"], '', $pro['nom']));
            $emailBase = iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $emailBase);
            $emailBase = preg_replace('/[^a-z0-9]/', '', $emailBase);
            $emailDomain = strtolower(str_replace([' ', '-', 'é', 'è'], '', $serviceName)) . '.local';
            $email = $emailBase . '@' . $emailDomain;
            
            // Vérifier si l'email existe déjà
            $emailCheckStmt = $conn->prepare("SELECT COUNT(*) as count FROM professionals WHERE email = :email");
            $emailCheckStmt->execute([':email' => $email]);
            $emailExists = $emailCheckStmt->fetch(PDO::FETCH_ASSOC)['count'] > 0;
            
            // Si l'email existe, ajouter un suffixe
            if ($emailExists) {
                $email = $emailBase . '_' . ($index + 1) . '@' . $emailDomain;
            }
            
            // Générer un ID unique
            $proId = 'pro_' . strtolower(str_replace([' ', '-', 'é', 'è'], '', $serviceName)) . '_' . uniqid();
            
            // Nettoyer le numéro de téléphone (garder seulement les chiffres et espaces)
            $phone = preg_replace('/[^0-9 ]/', '', $pro['phone']);
            // Si plusieurs numéros, prendre le premier
            if (strpos($phone, '/') !== false) {
                $phone = trim(explode('/', $phone)[0]);
            }
            $phone = '0' . str_replace(' ', '', $phone); // Format standard
            
            // Construire la localisation
            $location = $pro['district'] 
                ? $pro['district'] . ', ' . $pro['city']
                : $pro['city'];
            
            // Construire l'adresse
            $address = $pro['district'] 
                ? ($pro['district'] . ', ' . $pro['city'])
                : $pro['city'];
            
            // Générer un mot de passe par défaut (hashé)
            $defaultPassword = password_hash(strtolower($serviceName) . '123', PASSWORD_DEFAULT);
            
            // Insérer le professionnel
            $insertStmt = $conn->prepare("
                INSERT INTO professionals (
                    id, email, password, first_name, last_name, phone,
                    business_name, service_id, city, district, address, location,
                    description, base_price, certification_number, tax_id,
                    status, is_available, rating, reviews_count
                ) VALUES (
                    :id, :email, :password, :first_name, :last_name, :phone,
                    :business_name, :service_id, :city, :district, :address, :location,
                    :description, :base_price, :certification_number, :tax_id,
                    :status, :is_available, :rating, :reviews_count
                )
            ");
            
            $insertStmt->execute([
                ':id' => $proId,
                ':email' => $email,
                ':password' => $defaultPassword,
                ':first_name' => $firstName,
                ':last_name' => $lastName,
                ':phone' => $phone,
                ':business_name' => null,
                ':service_id' => $serviceId,
                ':city' => $pro['city'],
                ':district' => $pro['district'],
                ':address' => $address,
                ':location' => $location,
                ':description' => ' ',
                ':base_price' => 0.00,
                ':certification_number' => '0',
                ':tax_id' => '0',
                ':status' => 'verified',
                ':is_available' => 1,
                ':rating' => 0.0,
                ':reviews_count' => 0,
            ]);
            
            // Ajouter le service dans professional_services
            $serviceLinkStmt = $conn->prepare("
                INSERT INTO professional_services (professional_id, service_id)
                VALUES (:professional_id, :service_id)
                ON DUPLICATE KEY UPDATE professional_id = professional_id
            ");
            
            $serviceLinkStmt->execute([
                ':professional_id' => $proId,
                ':service_id' => $serviceId,
            ]);
            
            $inserted++;
            echo "✓ Ajouté: {$pro['nom']} ({$pro['city']}) - {$serviceName}\n";
            
        } catch (PDOException $e) {
            $errors[] = "Erreur pour {$pro['nom']} ({$serviceName}): " . $e->getMessage();
            echo "✗ Erreur pour {$pro['nom']} ({$serviceName}): " . $e->getMessage() . "\n";
        }
    }
    
    // Insérer les professionnels d'électricité
    echo "\n=== ÉLECTRICITÉ ===\n";
    foreach ($electriciteProfessionals as $index => $pro) {
        insertProfessional($conn, $pro, $electriciteServiceId, 'Electricité', $index, $inserted, $errors);
    }
    
    // Insérer les professionnels de menuiserie
    echo "\n=== MENUISERIE ===\n";
    foreach ($menuiserieProfessionals as $index => $pro) {
        insertProfessional($conn, $pro, $menuiserieServiceId, 'Menuiserie', $index, $inserted, $errors);
    }
    
    $conn->commit();
    
    echo "\n";
    echo "=== RÉSULTAT ===\n";
    echo "Professionnels ajoutés avec succès: $inserted\n";
    echo "Erreurs: " . count($errors) . "\n";
    
    if (!empty($errors)) {
        echo "\n=== ERREURS ===\n";
        foreach ($errors as $error) {
            echo "- $error\n";
        }
    }
    
    echo "\n✓ Tous les professionnels ont été insérés dans la base de données.\n";
    echo "</pre>\n";
    
} catch (Exception $e) {
    $conn->rollBack();
    echo "<h2 style='color: red;'>Erreur</h2>\n";
    echo "<pre>Erreur : " . $e->getMessage() . "</pre>\n";
}
?>
