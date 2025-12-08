<?php
/**
 * API endpoint pour récupérer les professionnels
 * 
 * Paramètres GET :
 * - service_id : Filtrer par service (optionnel)
 * - city : Filtrer par ville (optionnel)
 * - status : Filtrer par statut (optionnel) - valeurs : pending, verified, rejected, suspended
 * - available : Filtrer par disponibilité (optionnel) - valeurs : true, false
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Gérer les requêtes OPTIONS pour CORS
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Inclure la configuration de la base de données
require_once dirname(__DIR__) . '/db.php';

try {
    // Récupérer les paramètres de filtrage
    $serviceId = $_GET['service_id'] ?? null;
    $city = $_GET['city'] ?? null;
    $status = $_GET['status'] ?? null;
    $available = $_GET['available'] ?? null;
    
    // Construire la requête SQL
    $sql = "SELECT 
                p.id,
                p.email,
                p.first_name,
                p.last_name,
                p.phone,
                p.business_name,
                p.service_id,
                p.city,
                p.district,
                p.address,
                p.location,
                p.description,
                p.base_price,
                p.certification_number,
                p.tax_id,
                p.profile_image,
                p.status,
                p.is_available,
                p.rating,
                p.reviews_count,
                p.verified_at,
                p.created_at,
                p.updated_at,
                s.name as service_name,
                s.name_fr as service_name_fr
            FROM professionals p
            LEFT JOIN services s ON p.service_id = s.id
            WHERE 1=1";
    
    $params = [];
    
    // Appliquer les filtres
    if ($serviceId !== null && $serviceId !== '') {
        $sql .= " AND p.service_id = :service_id";
        $params[':service_id'] = $serviceId;
    }
    
    if ($city !== null && $city !== '') {
        $sql .= " AND p.city = :city";
        $params[':city'] = $city;
    }
    
    if ($status !== null && $status !== '') {
        $sql .= " AND p.status = :status";
        $params[':status'] = $status;
    } else {
        // Par défaut, ne montrer que les professionnels vérifiés
        $sql .= " AND p.status = 'verified'";
    }
    
    if ($available !== null && $available !== '') {
        $isAvailable = filter_var($available, FILTER_VALIDATE_BOOLEAN);
        $sql .= " AND p.is_available = :available";
        $params[':available'] = $isAvailable ? 1 : 0;
    }
    
    // Trier par ID décroissant (du plus récent au plus ancien)
    $sql .= " ORDER BY p.id DESC";
    
    // Préparer et exécuter la requête
    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    $professionals = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Créer un map des services pour les emojis
    $servicesStmt = $conn->query("SELECT id, name, name_fr FROM services");
    $allServices = $servicesStmt->fetchAll(PDO::FETCH_ASSOC);
    $servicesMap = [];
    foreach ($allServices as $srv) {
        $servicesMap[$srv['id']] = strtolower($srv['name_fr'] ?? $srv['name'] ?? '');
    }
    
    // Récupérer les services associés pour chaque professionnel
    foreach ($professionals as &$professional) {
        // Récupérer les services du professionnel depuis professional_services
        $servicesSql = "SELECT 
                            ps.service_id,
                            s.name as service_name,
                            s.name_fr as service_name_fr
                        FROM professional_services ps
                        LEFT JOIN services s ON ps.service_id = s.id
                        WHERE ps.professional_id = :professional_id";
        
        $servicesStmt = $conn->prepare($servicesSql);
        $servicesStmt->execute([':professional_id' => $professional['id']]);
        $professionalServices = $servicesStmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Construire la liste des services
        $servicesList = [];
        foreach ($professionalServices as $ps) {
            $servicesList[] = $ps['service_name_fr'] ?: $ps['service_name'];
        }
        $professional['services'] = $servicesList;
        
        // Construire le nom complet
        $firstName = trim($professional['first_name'] ?? '');
        $lastName = trim($professional['last_name'] ?? '');
        $businessName = trim($professional['business_name'] ?? '');
        $professional['name'] = !empty($businessName) 
            ? $businessName 
            : trim($firstName . ' ' . $lastName);
        
        // Nom du service principal
        $professional['service'] = !empty($professional['service_name_fr']) 
            ? $professional['service_name_fr'] 
            : ($professional['service_name'] ?? '');
        
        // Construire la localisation
        $city = trim($professional['city'] ?? '');
        $district = trim($professional['district'] ?? '');
        $location = trim($professional['location'] ?? '');
        
        if (empty($location)) {
            if (!empty($district) && !empty($city)) {
                $location = $district . ', ' . $city;
            } elseif (!empty($city)) {
                $location = $city;
            } elseif (!empty($district)) {
                $location = $district;
            } else {
                $location = '';
            }
        }
        $professional['location'] = $location;
        
        // Image de profil (emoji varié basé sur le service ou URL)
        // Essayer d'abord avec le service principal, puis avec le premier service multiple
        $emoji = null;
        if (!empty($professional['service_id'])) {
            $emoji = _getEmojiForService($professional['service_id'], $servicesMap, $professional['id']);
        }
        
        // Si pas d'emoji trouvé et qu'on a des services multiples, utiliser le premier
        if (($emoji === '👔' || empty($emoji)) && !empty($professionalServices)) {
            $firstService = $professionalServices[0];
            $firstServiceId = $firstService['service_id'] ?? null;
            if ($firstServiceId) {
                $emoji = _getEmojiForService($firstServiceId, $servicesMap, $professional['id']);
            }
        }
        
        $professional['image'] = !empty($professional['profile_image']) 
            ? $professional['profile_image'] 
            : ($emoji ?? '👔');
        
        // Note par défaut si null
        $professional['rating'] = isset($professional['rating']) && $professional['rating'] !== null
            ? (float)$professional['rating'] 
            : 0.0;
        $professional['reviews_count'] = isset($professional['reviews_count']) && $professional['reviews_count'] !== null
            ? (int)$professional['reviews_count'] 
            : 0;
        $professional['price'] = isset($professional['base_price']) && $professional['base_price'] !== null
            ? (float)$professional['base_price'] 
            : 0.00;
        $professional['isAvailable'] = isset($professional['is_available']) 
            ? (bool)$professional['is_available'] 
            : false;
    }
    
    // Retourner la réponse JSON
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => true,
        'data' => $professionals,
        'count' => count($professionals)
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    
} catch (PDOException $e) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    error_log('Erreur PDO dans get_professionals.php: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'error' => 'Erreur base de données: ' . $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ], JSON_UNESCAPED_UNICODE);
} catch (Exception $e) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    error_log('Erreur dans get_professionals.php: ' . $e->getMessage());
    echo json_encode([
        'success' => false,
        'error' => 'Erreur: ' . $e->getMessage(),
        'trace' => $e->getTraceAsString()
    ], JSON_UNESCAPED_UNICODE);
}

/**
 * Fonction pour obtenir un emoji varié basé sur le service
 * Les emojis sont répartis entre les professionnels du même service
 */
function _getEmojiForService($serviceId, $servicesMap, $professionalId = null) {
    // Récupérer le nom du service depuis le map
    $serviceName = isset($servicesMap[$serviceId]) ? strtolower($servicesMap[$serviceId]) : '';
    if (empty($serviceName)) {
        $serviceName = strtolower($serviceId);
    }
    
    // Mapping des services vers plusieurs emojis
    $emojiMap = [
        'plomberie' => ['🔧', '👨‍🔧', '👩‍🔧', '🚿', '💧', '🔩', '⚙️'],
        'plombier' => ['🔧', '👨‍🔧', '👩‍🔧', '🚿', '💧', '🔩', '⚙️'],
        'plumbing' => ['🔧', '👨‍🔧', '👩‍🔧', '🚿', '💧', '🔩', '⚙️'],
        'électricité' => ['⚡', '👨‍🔌', '👩‍🔌', '🔌', '💡', '⚙️', '🔋'],
        'électricien' => ['⚡', '👨‍🔌', '👩‍🔌', '🔌', '💡', '⚙️', '🔋'],
        'electricity' => ['⚡', '👨‍🔌', '👩‍🔌', '🔌', '💡', '⚙️', '🔋'],
        'peinture' => ['🎨', '👨‍🎨', '👩‍🎨', '🖌️', '🖼️', '🪣', '✨'],
        'peintre' => ['🎨', '👨‍🎨', '👩‍🎨', '🖌️', '🖼️', '🪣', '✨'],
        'painting' => ['🎨', '👨‍🎨', '👩‍🎨', '🖌️', '🖼️', '🪣', '✨'],
        'menuiserie' => ['🪚', '👷', '👷‍♀️', '🪵', '🔨', '⚒️', '🛠️'],
        'menuisier' => ['🪚', '👷', '👷‍♀️', '🪵', '🔨', '⚒️', '🛠️'],
        'carpentry' => ['🪚', '👷', '👷‍♀️', '🪵', '🔨', '⚒️', '🛠️'],
        'nettoyage' => ['🧹', '👨‍💼', '👩‍💼', '🧽', '✨', '🧴', '🧼'],
        'nettoyeur' => ['🧹', '👨‍💼', '👩‍💼', '🧽', '✨', '🧴', '🧼'],
        'cleaning' => ['🧹', '👨‍💼', '👩‍💼', '🧽', '✨', '🧴', '🧼'],
        'jardinage' => ['🌳', '👨‍🌾', '👩‍🌾', '🌱', '🌿', '🍃', '🌲'],
        'jardinier' => ['🌳', '👨‍🌾', '👩‍🌾', '🌱', '🌿', '🍃', '🌲'],
        'gardening' => ['🌳', '👨‍🌾', '👩‍🌾', '🌱', '🌿', '🍃', '🌲'],
        'chauffage' => ['🔥', '👨‍🔧', '👩‍🔧', '⚡', '🌡️', '🛠️', '⚙️'],
        'chauffagiste' => ['🔥', '👨‍🔧', '👩‍🔧', '⚡', '🌡️', '🛠️', '⚙️'],
        'heating' => ['🔥', '👨‍🔧', '👩‍🔧', '⚡', '🌡️', '🛠️', '⚙️'],
        'électronique' => ['🔌', '👨‍🔬', '👩‍🔬', '💻', '📱', '⌚', '🔋'],
        'electronique' => ['🔌', '👨‍🔬', '👩‍🔬', '💻', '📱', '⌚', '🔋'],
        'maçonnerie' => ['🧱', '👷', '👷‍♀️', '🏗️', '🔨', '⚒️', '🛠️'],
        'maçon' => ['🧱', '👷', '👷‍♀️', '🏗️', '🔨', '⚒️', '🛠️'],
        'parabole' => ['📡', '👨‍💻', '👩‍💻', '📺', '📶', '🛰️', '📻'],
        'vitrerie' => ['🪟', '👨‍🔧', '👩‍🔧', '🔩', '⚙️', '🛠️', '✨'],
        'aluminium' => ['🪟', '👨‍🔧', '👩‍🔧', '🔩', '⚙️', '🛠️', '✨'],
        'climatisation' => ['❄️', '🌡️', '💨', '❄', '🌀', '🌬️', '🧊'],
        'froid' => ['❄️', '🌡️', '💨', '❄', '🌀', '🌬️', '🧊'],
        'serrurerie' => ['🔐', '👨‍🔧', '👩‍🔧', '🔑', '🚪', '⚙️', '🛠️'],
        'serrurier' => ['🔐', '👨‍🔧', '👩‍🔧', '🔑', '🚪', '⚙️', '🛠️'],
        'plâtrier' => ['🧹', '👷', '👷‍♀️', '🪣', '⚒️', '🛠️', '✨'],
        'ferronnerie' => ['⚙️', '👨‍🔧', '👩‍🔧', '🔩', '🛠️', '⚒️', '🔨'],
        'surveillance' => ['🚨', '👨‍💼', '👩‍💼', '📹', '🔒', '🛡️', '👁️'],
        'alarmes' => ['🚨', '👨‍💼', '👩‍💼', '📹', '🔒', '🛡️', '👁️'],
        'étanchéité' => ['💧', '👨‍🔧', '👩‍🔧', '🛡️', '🌊', '⚙️', '🔧'],
        'etancheite' => ['💧', '👨‍🔧', '👩‍🔧', '🛡️', '🌊', '⚙️', '🔧'],
        'carrelage' => ['🧱', '👷', '👷‍♀️', '🔨', '⚒️', '🛠️', '✨'],
        'électroménager' => ['🏠', '👨‍🔧', '👩‍🔧', '⚡', '🔌', '🛠️', '⚙️'],
        'electromenager' => ['🏠', '👨‍🔧', '👩‍🔧', '⚡', '🔌', '🛠️', '⚙️'],
        'mécanique' => ['🔧', '👨‍🔧', '👩‍🔧', '🚗', '⚙️', '🛠️', '🔩'],
        'mecanique' => ['🔧', '👨‍🔧', '👩‍🔧', '🚗', '⚙️', '🛠️', '🔩'],
        'transport' => ['🚚', '👨‍✈️', '👩‍✈️', '🚗', '🚐', '🚛', '📦'],
        'tapisserie' => ['🛋️', '👨‍🎨', '👩‍🎨', '🖼️', '✨', '🎨', '🪑'],
        'ascenseurs' => ['⬆️', '👨‍🔧', '👩‍🔧', '⚙️', '🛠️', '🔩', '🏢'],
        'démolition' => ['🏗️', '👷', '👷‍♀️', '🔨', '⚒️', '💥', '🛠️'],
        'demolition' => ['🏗️', '👷', '👷‍♀️', '🔨', '⚒️', '💥', '🛠️'],
        'encadrement' => ['🖼️', '👨‍🎨', '👩‍🎨', '🎨', '✨', '🖌️', '📐'],
        'pneumatiques' => ['🛞', '👨‍🔧', '👩‍🔧', '🚗', '⚙️', '🔩', '🛠️'],
        'marbre' => ['💎', '👷', '👷‍♀️', '✨', '🪨', '⚒️', '🛠️'],
        'dépannage' => ['🆘', '👨‍🔧', '👩‍🔧', '🔧', '⚙️', '🛠️', '⚡'],
        'depannage' => ['🆘', '👨‍🔧', '👩‍🔧', '🔧', '⚙️', '🛠️', '⚡'],
        'piscine' => ['🏊', '👨‍🔧', '👩‍🔧', '💧', '🌊', '🔧', '⚙️'],
    ];
    
    // Chercher dans le map
    $emojis = null;
    foreach ($emojiMap as $key => $emojiList) {
        if (stripos($serviceName, $key) !== false || stripos($serviceId, $key) !== false) {
            $emojis = $emojiList;
            break;
        }
    }
    
    // Si pas d'emojis trouvés, utiliser l'emoji par défaut
    if ($emojis === null || empty($emojis)) {
        return '👔';
    }
    
    // Répartir les emojis entre les professionnels en fonction de l'ID
    if ($professionalId !== null) {
        // Utiliser l'ID du professionnel pour déterminer l'index de l'emoji
        // Convertir l'ID en nombre pour avoir une distribution cohérente
        $hash = crc32($professionalId);
        $index = abs($hash) % count($emojis);
        return $emojis[$index];
    }
    
    // Si pas d'ID, retourner le premier emoji
    return $emojis[0];
}
?>
