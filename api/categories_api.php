<?php
/**
 * API CRUD pour les catégories
 * 
 * GET    /api/categories_api.php          - Liste toutes les catégories
 * GET    /api/categories_api.php?id=X     - Récupère une catégorie
 * POST   /api/categories_api.php          - Crée une catégorie
 * PUT    /api/categories_api.php          - Met à jour une catégorie
 * DELETE /api/categories_api.php?id=X     - Supprime une catégorie
 */

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$dbPath = __DIR__ . '/../db.php';
if (!file_exists($dbPath)) {
    $dbPath = __DIR__ . '/../../db.php';
}
require_once $dbPath;

$method = $_SERVER['REQUEST_METHOD'];

try {
    switch ($method) {
        case 'GET':
            if (isset($_GET['id'])) {
                // Récupérer une catégorie
                $stmt = $conn->prepare("SELECT * FROM categories WHERE id = :id");
                $stmt->execute([':id' => $_GET['id']]);
                $category = $stmt->fetch(PDO::FETCH_ASSOC);
                
                if ($category) {
                    echo json_encode(['success' => true, 'data' => $category], JSON_UNESCAPED_UNICODE);
                } else {
                    http_response_code(404);
                    echo json_encode(['success' => false, 'error' => 'Catégorie non trouvée'], JSON_UNESCAPED_UNICODE);
                }
            } else {
                // Lister toutes les catégories
                $lang = $_GET['lang'] ?? 'fr';
                $stmt = $conn->prepare("SELECT * FROM categories ORDER BY id ASC");
                $stmt->execute();
                $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
                
                $formatted = [];
                foreach ($categories as $cat) {
                    $name = $cat['name'];
                    if ($lang === 'fr' && !empty($cat['name_fr'])) $name = $cat['name_fr'];
                    elseif ($lang === 'ar' && !empty($cat['name_ar'])) $name = $cat['name_ar'];
                    elseif ($lang === 'darija' && !empty($cat['name_darija'])) $name = $cat['name_darija'];
                    
                    $formatted[] = [
                        'id' => $cat['id'],
                        'name' => $name,
                        'icon' => $cat['icon'],
                        'description' => $cat['description'],
                        'color' => $cat['color']
                    ];
                }
                
                echo json_encode(['success' => true, 'data' => $formatted, 'count' => count($formatted)], JSON_UNESCAPED_UNICODE);
            }
            break;
            
        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);
            if (!$data) $data = $_POST;
            
            $stmt = $conn->prepare("
                INSERT INTO categories (id, name, name_fr, name_ar, name_darija, icon, description, color)
                VALUES (:id, :name, :name_fr, :name_ar, :name_darija, :icon, :description, :color)
            ");
            
            $stmt->execute([
                ':id' => $data['id'] ?? uniqid('cat_'),
                ':name' => $data['name'],
                ':name_fr' => $data['name_fr'] ?? $data['name'],
                ':name_ar' => $data['name_ar'] ?? null,
                ':name_darija' => $data['name_darija'] ?? null,
                ':icon' => $data['icon'] ?? null,
                ':description' => $data['description'] ?? null,
                ':color' => $data['color'] ?? '#2196F3'
            ]);
            
            echo json_encode(['success' => true, 'id' => $conn->lastInsertId()], JSON_UNESCAPED_UNICODE);
            break;
            
        case 'PUT':
            $data = json_decode(file_get_contents('php://input'), true);
            if (!$data) parse_str(file_get_contents('php://input'), $data);
            
            $stmt = $conn->prepare("
                UPDATE categories 
                SET name = :name, name_fr = :name_fr, name_ar = :name_ar, name_darija = :name_darija,
                    icon = :icon, description = :description, color = :color
                WHERE id = :id
            ");
            
            $stmt->execute([
                ':id' => $data['id'],
                ':name' => $data['name'],
                ':name_fr' => $data['name_fr'] ?? $data['name'],
                ':name_ar' => $data['name_ar'] ?? null,
                ':name_darija' => $data['name_darija'] ?? null,
                ':icon' => $data['icon'] ?? null,
                ':description' => $data['description'] ?? null,
                ':color' => $data['color'] ?? '#2196F3'
            ]);
            
            echo json_encode(['success' => true], JSON_UNESCAPED_UNICODE);
            break;
            
        case 'DELETE':
            $id = $_GET['id'] ?? json_decode(file_get_contents('php://input'), true)['id'] ?? null;
            if (!$id) {
                throw new Exception('ID requis');
            }
            
            $stmt = $conn->prepare("DELETE FROM categories WHERE id = :id");
            $stmt->execute([':id' => $id]);
            
            echo json_encode(['success' => true], JSON_UNESCAPED_UNICODE);
            break;
            
        default:
            http_response_code(405);
            echo json_encode(['success' => false, 'error' => 'Méthode non autorisée'], JSON_UNESCAPED_UNICODE);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => $e->getMessage()], JSON_UNESCAPED_UNICODE);
}
?>
