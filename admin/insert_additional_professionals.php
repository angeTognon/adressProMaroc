<?php
/**
 * Script pour insérer les professionnels supplémentaires
 * Services: Électronique, Maçonnerie, Peinture, Parabole, Serrurerie
 * 
 * Usage: Accéder à cette page via navigateur ou exécuter via CLI
 */

require_once '../db.php';

// Données des professionnels par service
$professionalsByService = [
    'Électronique' => [
        ['nom' => 'SWALEH Miloud', 'phone' => '06 66 45 37 16', 'city' => 'Marrakech', 'district' => 'Al Massira', 'address' => null],
        ['nom' => 'ENNAIM Aziz', 'phone' => '06 67 01 41 94', 'city' => 'Marrakech', 'district' => 'Al Massira', 'address' => null],
        ['nom' => 'AIT BATAMI Ibrahim', 'phone' => '06 64 28 72 14', 'city' => 'Salé', 'district' => 'Tabriquet', 'address' => null],
        ['nom' => 'ECHERKAOUI Chihab', 'phone' => '06 61 58 75 57', 'city' => 'Salé', 'district' => 'Hay Essalam', 'address' => null],
        ['nom' => 'MSLINK Samir', 'phone' => '06 61 59 16 67', 'city' => 'Rabat', 'district' => null, 'address' => '27 AV SIDI MOUHAMMED BEN ABDELAH AKARI'],
        ['nom' => 'AZZOUZI Hassan', 'phone' => '0661055433', 'city' => 'Kénitra', 'district' => null, 'address' => 'RAS'],
        ['nom' => 'elmardi minhaj', 'phone' => '0663266910', 'city' => 'Fés', 'district' => null, 'address' => '16,rue21 oued fes'],
    ],
    'Maçonnerie' => [
        ['nom' => 'BIHI Larbi', 'phone' => '06 41 90 30 04', 'city' => 'Salé', 'district' => 'Tabriquet', 'address' => null],
        ['nom' => 'BENTOUNSI Mhammed', 'phone' => '06 71 94 74 39', 'city' => 'Salé', 'district' => null, 'address' => null],
        ['nom' => 'DRAOUI Boucelham', 'phone' => '06 11 33 09 20', 'city' => 'kenitra', 'district' => 'Saknia', 'address' => null],
    ],
    'Peinture' => [
        ['nom' => 'BOUHADOUFI Tarik', 'phone' => '06 64 81 26 73', 'city' => 'Kenitra', 'district' => 'la ville haute', 'address' => null],
        ['nom' => 'AMGHAR said', 'phone' => '06 14 62 72 86', 'city' => 'Kenitra', 'district' => 'la ville haute', 'address' => null],
        ['nom' => 'BOUMEHDI Mohammed', 'phone' => '06 65 95 17 68', 'city' => 'Fès', 'district' => null, 'address' => null],
        ['nom' => 'TALHA Karim', 'phone' => '06 99 90 98 57', 'city' => 'Fès', 'district' => null, 'address' => null],
        ['nom' => 'EL OUARDI Elarbi', 'phone' => '06 60 56 93 57', 'city' => 'Casablanca', 'district' => 'Yasmina', 'address' => null],
        ['nom' => 'TWAHRI Ghrib', 'phone' => '06 62 88 87 83', 'city' => 'Salé', 'district' => 'Laayayda', 'address' => null],
        ['nom' => 'ESSADKKI Hammadi', 'phone' => '06 71 69 67 00', 'city' => 'Salé', 'district' => null, 'address' => null],
        ['nom' => 'KHATTABI Bouchib', 'phone' => '06 65 23 36 32', 'city' => 'Salé', 'district' => 'Laayayda', 'address' => null],
        ['nom' => 'NHNAK Ali', 'phone' => '06 18 79 62 54', 'city' => 'Casablanca', 'district' => null, 'address' => null],
    ],
    'Parabole' => [
        ['nom' => 'CHOWAY Mounir', 'phone' => '06 61 51 21 77', 'city' => 'Casablanca', 'district' => 'Bourgogne', 'address' => null],
        ['nom' => 'EL MLIHI Simohamed', 'phone' => '06 78 78 17 66', 'city' => 'Casablanca', 'district' => 'Sidi Bernoussi', 'address' => null],
        ['nom' => 'CHETIWI Ahmed', 'phone' => '06 66 73 02 43', 'city' => 'Rabat', 'district' => 'Takaddoum', 'address' => null],
        ['nom' => 'AMRAN Toufik', 'phone' => '06 77 01 78 15', 'city' => 'Temara', 'district' => 'Al Wifak', 'address' => null],
        ['nom' => 'EL MARSSAOUI Said', 'phone' => '06 75 37 49 94', 'city' => 'Marrakech', 'district' => 'Abwab Marrakech', 'address' => null],
        ['nom' => 'EL MOUNA FOUAD', 'phone' => '06 60 06 73 50', 'city' => 'Marrakech', 'district' => 'Abwab Marrakech', 'address' => null],
    ],
    'Serrurerie' => [
        ['nom' => 'AIT OMAR Abdelaziz', 'phone' => '06 67 53 74 70', 'city' => 'Kenitra', 'district' => 'la ville haute', 'address' => null],
        ['nom' => 'KHAOUTI Hassan', 'phone' => '06 74 71 05 59', 'city' => 'Casablanca', 'district' => 'Verdin', 'address' => null],
        ['nom' => 'SEFFAF Mohammed', 'phone' => '06 64 34 83 38', 'city' => 'Meknès', 'district' => 'Ville Nouvelle', 'address' => null],
        ['nom' => 'BENTITTA Abdessamad', 'phone' => '06 31 51 55 60', 'city' => 'Meknès', 'district' => 'Ville Nouvelle', 'address' => null],
    ],
];

try {
    // Récupérer tous les IDs de services
    $servicesMap = [];
    foreach (array_keys($professionalsByService) as $serviceName) {
        // Recherche flexible pour différents noms
        $searchPattern = '%' . $serviceName . '%';
        
        $serviceStmt = $conn->prepare("
            SELECT id FROM services 
            WHERE name_fr LIKE :pattern 
               OR name LIKE :pattern
            LIMIT 1
        ");
        
        $serviceStmt->execute([':pattern' => $searchPattern]);
        $service = $serviceStmt->fetch(PDO::FETCH_ASSOC);
        
        // Si pas trouvé, essayer sans accents
        if (!$service && (strpos($serviceName, 'É') !== false || strpos($serviceName, 'é') !== false)) {
            $serviceNameNoAccent = str_replace(['É', 'é'], ['E', 'e'], $serviceName);
            $searchPattern = '%' . $serviceNameNoAccent . '%';
            $serviceStmt->execute([':pattern' => $searchPattern]);
            $service = $serviceStmt->fetch(PDO::FETCH_ASSOC);
        }
        
        if (!$service) {
            throw new Exception("Service '$serviceName' non trouvé dans la base de données. Veuillez d'abord créer ce service.");
        }
        
        $servicesMap[$serviceName] = $service['id'];
        echo "Service '$serviceName' trouvé: ID = {$service['id']}\n";
    }
    
    echo "<h2>Insertion des professionnels supplémentaires</h2>\n";
    echo "<pre>\n";
    echo "\n";
    
    $conn->beginTransaction();
    
    $inserted = 0;
    $errors = [];
    $globalIndex = 0;
    
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
            $emailDomain = strtolower(str_replace([' ', '-', 'é', 'è', 'É'], ['', '', 'e', 'e', 'e'], $serviceName)) . '.local';
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
            $serviceSlug = strtolower(str_replace([' ', '-', 'é', 'è', 'É'], ['', '', 'e', 'e', 'e'], $serviceName));
            $proId = 'pro_' . $serviceSlug . '_' . uniqid();
            
            // Nettoyer le numéro de téléphone (garder seulement les chiffres et espaces)
            $phone = preg_replace('/[^0-9 ]/', '', $pro['phone']);
            // Si plusieurs numéros, prendre le premier
            if (strpos($phone, '/') !== false) {
                $phone = trim(explode('/', $phone)[0]);
            }
            // Normaliser le format (supprimer les espaces)
            $phone = str_replace(' ', '', $phone);
            // S'assurer qu'il commence par 0
            if (substr($phone, 0, 1) !== '0') {
                $phone = '0' . $phone;
            }
            
            // Construire l'adresse
            $address = '';
            if (!empty($pro['address'])) {
                $address = $pro['address'];
                if ($pro['district']) {
                    $address .= ', ' . $pro['district'];
                }
                $address .= ', ' . $pro['city'];
            } else if ($pro['district']) {
                $address = $pro['district'] . ', ' . $pro['city'];
            } else {
                $address = $pro['city'];
            }
            
            // Construire la localisation
            $location = $pro['district'] 
                ? $pro['district'] . ', ' . $pro['city']
                : $pro['city'];
            
            // Normaliser la ville (première lettre en majuscule)
            $city = ucfirst(strtolower(trim($pro['city'])));
            
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
                ':city' => $city,
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
    
    // Insérer les professionnels pour chaque service
    foreach ($professionalsByService as $serviceName => $professionals) {
        echo "\n=== {$serviceName} ===\n";
        $serviceId = $servicesMap[$serviceName];
        
        foreach ($professionals as $index => $pro) {
            insertProfessional($conn, $pro, $serviceId, $serviceName, $globalIndex, $inserted, $errors);
            $globalIndex++;
        }
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
