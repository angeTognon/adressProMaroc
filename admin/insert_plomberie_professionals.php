<?php
/**
 * Script pour insérer les professionnels de plomberie
 * 
 * Usage: Accéder à cette page via navigateur ou exécuter via CLI
 */

require_once '../db.php';

// Données des professionnels
$professionals = [
    ['nom' => 'EL HADDA Houssine', 'phone' => '06 67 58 48 53', 'city' => 'Kenitra', 'district' => 'la ville haute'],
    ['nom' => 'JMMAN Molamed', 'phone' => '06 64 01 45 24', 'city' => 'Kenitra', 'district' => 'la ville haute'],
    ['nom' => 'ELWARDI Hassan', 'phone' => '06 53 69 87 70', 'city' => 'Casablanca', 'district' => 'Avenue Bordeaux'],
    ['nom' => 'EDDAIF Abdelmajid', 'phone' => '06 68 17 27 07', 'city' => 'Casablanca', 'district' => 'Anfa'],
    ['nom' => 'FADLI Abdelkarim', 'phone' => '06 42 75 38 93', 'city' => 'Casablanca', 'district' => 'Verdin'],
    ['nom' => 'KOKAJI Simohamed', 'phone' => '06 65 83 19 61', 'city' => 'Casablanca', 'district' => 'Bourgogne'],
    ['nom' => 'ELGARMA Said', 'phone' => '06 75 47 64 51', 'city' => 'Casablanca', 'district' => 'Bourgogne'],
    ['nom' => 'EL GOUILI Lahcen', 'phone' => '06 67 03 66 91', 'city' => 'Salé', 'district' => 'Tabriquet'],
    ['nom' => 'IBRAHIMI Idrisse', 'phone' => '06 60 36 77 14', 'city' => 'Salé', 'district' => 'Hay Essalam'],
    ['nom' => 'NACHID Abderrahim', 'phone' => '06 70 32 02 58', 'city' => 'Sidi Bennour', 'district' => null],
    ['nom' => 'MOURAD Rachid', 'phone' => '06 14 63 87 87', 'city' => 'Casablanca', 'district' => 'Sidi Bernoussi'],
    ['nom' => 'AMROUG Hamid', 'phone' => '06 10 88 35 16', 'city' => 'Casablanca', 'district' => 'Sidi Bernoussi'],
    ['nom' => 'ARGAZ Said', 'phone' => '06 00 57 29 47', 'city' => 'Casablanca', 'district' => 'Ain Sebaa'],
    ['nom' => 'RAOUF Hicham', 'phone' => '06 62 16 68 34', 'city' => 'Casablanca', 'district' => null],
    ['nom' => 'ENNAKRI Abdelhadi', 'phone' => '06 15 74 15 33', 'city' => 'Casablanca', 'district' => null],
    ['nom' => 'BEL KHADRASSI Abdelkarim', 'phone' => '06 67 26 85 15', 'city' => 'Casablanca', 'district' => null],
    ['nom' => 'BEN ARBIA Rachid', 'phone' => '06 66 30 30 44', 'city' => 'Casablanca', 'district' => null],
    ['nom' => 'AL MISRA Aziz', 'phone' => '06 71 46 18 99', 'city' => 'Casablanca', 'district' => 'Sidi Moumen'],
    ['nom' => 'SENHAJI Abdennabi', 'phone' => '06 62 01 74 59', 'city' => 'Casablanca', 'district' => 'Ain Harrouda'],
    ['nom' => 'EL MAHDI Tabit', 'phone' => '06 69 62 61 64', 'city' => 'Salé', 'district' => null],
    ['nom' => 'ENNASRAOUI Jamal', 'phone' => '06 41 14 66 24', 'city' => 'Rabat', 'district' => null],
    ['nom' => 'SMOUNI Mohamed', 'phone' => '06 65 23 40 13/06 66 11 42 64', 'city' => 'Rabat', 'district' => null],
    ['nom' => 'SOUHADI Mohamed', 'phone' => '06 22 68 47 03/06 77 92 19 67', 'city' => 'Rabat', 'district' => null],
    ['nom' => 'EL BARMAKI Aziz', 'phone' => '06 60 89 36 33 / 06 69 06 21 18', 'city' => 'Temara', 'district' => null],
    ['nom' => 'BENDADNI Bendadani', 'phone' => '05 37 69 91 93', 'city' => 'Rabat', 'district' => null],
    ['nom' => 'EL HAOUACH Abdelouahed', 'phone' => '06 62 63 84 78', 'city' => 'Temara', 'district' => null],
    ['nom' => 'MBOUKI Omar', 'phone' => '06 73 30 49 49', 'city' => 'Rabat', 'district' => 'Takaddoum'],
    ['nom' => 'AADIM Youssef', 'phone' => '06 74 37 23 73', 'city' => 'Rabat', 'district' => 'El Akkari'],
    ['nom' => 'BOU INAN Abdelghani', 'phone' => '06 65 06 66 18 / 06 35 46 39 75', 'city' => 'Rabat', 'district' => 'Yacoub Al Mansour'],
    ['nom' => 'AL MOHANDISS Abderrahim', 'phone' => '06 70 94 05 83', 'city' => 'Rabat', 'district' => 'El Akkari'],
    ['nom' => 'MELIANI Majid', 'phone' => '06 61 75 93 25', 'city' => 'Fès', 'district' => null],
    ['nom' => 'AIT BRAHIM Mohamed', 'phone' => '06 41 71 56 82', 'city' => 'Casablanca', 'district' => 'Bourgogne'],
    ['nom' => 'ENNAINI Aziz', 'phone' => '06 38 11 65 78', 'city' => 'Casablanca', 'district' => 'Anfa'],
    ['nom' => 'ELASSOULI Houcine', 'phone' => '06 61 85 20 20', 'city' => 'Casablanca', 'district' => 'Anfa'],
    ['nom' => 'KECHAF Rachid', 'phone' => '06 63 59 06 10', 'city' => 'Casablanca', 'district' => 'Verdin'],
    ['nom' => 'ERAYHANI Khalid', 'phone' => '06 64 74 33 46', 'city' => 'Casablanca', 'district' => 'Verdin'],
    ['nom' => 'ALAMARI Abdelkarim', 'phone' => '06 73 53 36 09', 'city' => 'Kenitra', 'district' => 'La Ville Haute'],
    ['nom' => 'JANANE Abderrahim', 'phone' => '06 62 27 72 53', 'city' => 'Temara', 'district' => null],
];

try {
    // Trouver l'ID du service Plomberie
    $plomberieServiceStmt = $conn->prepare("SELECT id FROM services WHERE name_fr LIKE '%Plomberie%' OR name LIKE '%Plomberie%' OR name LIKE '%Plumbing%' LIMIT 1");
    $plomberieServiceStmt->execute();
    $plomberieService = $plomberieServiceStmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$plomberieService) {
        throw new Exception("Service Plomberie non trouvé dans la base de données. Veuillez d'abord créer ce service.");
    }
    
    $plomberieServiceId = $plomberieService['id'];
    echo "<h2>Insertion des professionnels de plomberie</h2>\n";
    echo "<pre>\n";
    echo "Service Plomberie trouvé: ID = $plomberieServiceId\n\n";
    
    $conn->beginTransaction();
    
    $inserted = 0;
    $errors = [];
    
    foreach ($professionals as $index => $pro) {
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
            $email = $emailBase . '@plomberie.local';
            
            // Vérifier si l'email existe déjà
            $emailCheckStmt = $conn->prepare("SELECT COUNT(*) as count FROM professionals WHERE email = :email");
            $emailCheckStmt->execute([':email' => $email]);
            $emailExists = $emailCheckStmt->fetch(PDO::FETCH_ASSOC)['count'] > 0;
            
            // Si l'email existe, ajouter un suffixe
            if ($emailExists) {
                $email = $emailBase . '_' . ($index + 1) . '@plomberie.local';
            }
            
            // Générer un ID unique
            $proId = 'pro_plomberie_' . uniqid();
            
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
            $defaultPassword = password_hash('plomberie123', PASSWORD_DEFAULT);
            
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
                ':service_id' => $plomberieServiceId,
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
                ':service_id' => $plomberieServiceId,
            ]);
            
            $inserted++;
            echo "✓ Ajouté: {$pro['nom']} ({$pro['city']})\n";
            
        } catch (PDOException $e) {
            $errors[] = "Erreur pour {$pro['nom']}: " . $e->getMessage();
            echo "✗ Erreur pour {$pro['nom']}: " . $e->getMessage() . "\n";
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
