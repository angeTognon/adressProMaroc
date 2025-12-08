<?php
/**
 * API GET - Récupération des services
 * 
 * Endpoint: GET /api/get_services.php
 * 
 * Paramètres optionnels:
 * - lang: Langue (fr, ar, darija) - Défaut: fr
 * - active: Filtrer uniquement les services actifs (1) - Défaut: 1
 * 
 * Réponse JSON:
 * {
 *   "success": true,
 *   "data": [
 *     {
 *       "id": "1",
 *       "name": "Plomberie",
 *       "name_fr": "Plomberie",
 *       "icon": "🔧",
 *       "description": "Réparation et installation de plomberie",
 *       "color": "#2196F3"
 *     },
 *     ...
 *   ],
 *   "count": 8
 * }
 */

// Headers pour JSON et CORS
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Gérer les requêtes OPTIONS (preflight)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Vérifier que la méthode est GET
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode([
        'success' => false,
        'error' => 'Méthode non autorisée. Utilisez GET.'
    ]);
    exit();
}

// Ajuster le chemin selon votre structure
// Le fichier db.php doit être dans le dossier parent du dossier api/
$dbPath = dirname(__DIR__) . '/db.php';
if (!file_exists($dbPath)) {
    // Essayer un autre chemin si nécessaire
    $dbPath = __DIR__ . '/../db.php';
}

if (!file_exists($dbPath)) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Fichier db.php non trouvé. Vérifiez la structure des fichiers.'
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

require_once $dbPath;

try {
    // Récupérer les paramètres
    $lang = isset($_GET['lang']) ? $_GET['lang'] : 'fr';
    $activeOnly = isset($_GET['active']) ? (int)$_GET['active'] : 1;
    
    // Construire la requête SQL
    $sql = "SELECT 
                id,
                name,
                name_fr,
                name_ar,
                name_darija,
                icon,
                description,
                color,
                is_active,
                created_at,
                updated_at
            FROM services";
    
    $params = [];
    
    // Ajouter le filtre actif
    if ($activeOnly) {
        $sql .= " WHERE is_active = 1";
    }
    
    // Trier par ID décroissant (du plus récent au plus ancien)
    $sql .= " ORDER BY id DESC";
    
    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    $services = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Formater les données selon la langue
    $formattedServices = [];
    foreach ($services as $service) {
        // Sélectionner le nom selon la langue
        $serviceName = $service['name']; // Par défaut
        if ($lang === 'fr' && !empty($service['name_fr'])) {
            $serviceName = $service['name_fr'];
        } elseif ($lang === 'ar' && !empty($service['name_ar'])) {
            $serviceName = $service['name_ar'];
        } elseif ($lang === 'darija' && !empty($service['name_darija'])) {
            $serviceName = $service['name_darija'];
        }
        
        $formattedServices[] = [
            'id' => $service['id'],
            'name' => $serviceName,
            'icon' => $service['icon'],
            'description' => $service['description'],
            'color' => $service['color'],
            'isActive' => (bool)$service['is_active']
        ];
    }
    
    // Réponse JSON
    echo json_encode([
        'success' => true,
        'data' => $formattedServices,
        'count' => count($formattedServices),
        'lang' => $lang
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Erreur serveur lors de la récupération des services',
        'message' => $e->getMessage()
    ], JSON_UNESCAPED_UNICODE);
}
?>
