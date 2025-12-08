<?php
/**
 * Interface d'administration CRUD complète
 * Gestion des tables : services, professionals, users
 */

session_start();

// Protection basique (à améliorer en production avec authentification)
// Pour l'instant, on peut accéder directement ou ajouter un mot de passe simple
$admin_password = 'admin123'; // Changez ce mot de passe !

if (!isset($_SESSION['admin_logged_in'])) {
    if (isset($_POST['password']) && $_POST['password'] === $admin_password) {
        $_SESSION['admin_logged_in'] = true;
    } elseif (!isset($_POST['password'])) {
        // Afficher le formulaire de connexion
        ?>
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Administration - Connexion</title>
            <style>
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    padding: 20px;
                }
                .login-container {
                    background: white;
                    padding: 40px;
                    border-radius: 20px;
                    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
                    max-width: 400px;
                    width: 100%;
                }
                h1 {
                    color: #333;
                    margin-bottom: 30px;
                    text-align: center;
                    font-size: 28px;
                }
                input[type="password"] {
                    width: 100%;
                    padding: 15px;
                    border: 2px solid #e0e0e0;
                    border-radius: 10px;
                    font-size: 16px;
                    margin-bottom: 20px;
                    transition: border-color 0.3s;
                }
                input[type="password"]:focus {
                    outline: none;
                    border-color: #667eea;
                }
                button {
                    width: 100%;
                    padding: 15px;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    border: none;
                    border-radius: 10px;
                    font-size: 16px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: transform 0.2s;
                }
                button:hover {
                    transform: translateY(-2px);
                }
                .error {
                    background: #fee;
                    color: #c33;
                    padding: 12px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    text-align: center;
                }
            </style>
        </head>
        <body>
            <div class="login-container">
                <h1>🔐 Administration</h1>
                <?php if (isset($_POST['password']) && $_POST['password'] !== $admin_password): ?>
                    <div class="error">Mot de passe incorrect</div>
                <?php endif; ?>
                <form method="POST">
                    <input type="password" name="password" placeholder="Mot de passe administrateur" required>
                    <button type="submit">Se connecter</button>
                </form>
            </div>
        </body>
        </html>
        <?php
        exit;
    } else {
        ?>
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <title>Administration - Connexion</title>
        </head>
        <body>
            <form method="POST">
                <input type="password" name="password" placeholder="Mot de passe">
                <button type="submit">Connexion</button>
            </form>
        </body>
        </html>
        <?php
        exit;
    }
}

require_once '../db.php';

// Gestion des actions AJAX
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    header('Content-Type: application/json');
    
    $action = $_POST['action'];
    $table = $_POST['table'] ?? '';
    
    try {
        switch ($action) {
            case 'create':
                $result = createRecord($conn, $table, $_POST);
                echo json_encode($result);
                break;
            case 'update':
                if (!isset($_POST['id']) || empty($_POST['id'])) {
                    echo json_encode(['success' => false, 'error' => 'ID requis pour la mise à jour']);
                    exit;
                }
                $result = updateRecord($conn, $table, $_POST);
                echo json_encode($result);
                break;
            case 'delete':
                // Pour la suppression, on accepte soit un ID, soit un nom (pour les services sans ID)
                $id = $_POST['id'] ?? null;
                $name = $_POST['name'] ?? null;
                
                // Nettoyer les valeurs
                $id = !empty($id) ? trim($id) : null;
                $name = !empty($name) ? trim($name) : null;
                
                if (empty($id) && empty($name)) {
                    echo json_encode(['success' => false, 'error' => 'ID ou nom requis pour la suppression']);
                    exit;
                }
                
                $result = deleteRecord($conn, $table, $id, $name);
                echo json_encode($result);
                break;
            case 'get':
                if (!isset($_POST['id']) || empty($_POST['id'])) {
                    echo json_encode(['success' => false, 'error' => 'ID requis']);
                    exit;
                }
                $result = getRecord($conn, $table, $_POST['id']);
                echo json_encode($result);
                break;
            case 'get_all':
                if ($table === 'services') {
                    $services = getAllRecords($conn, 'services');
                    echo json_encode(['success' => true, 'data' => $services]);
                } else {
                    echo json_encode(['success' => false, 'error' => 'Table non supportée']);
                }
                exit;
                break;
            default:
                echo json_encode(['success' => false, 'error' => 'Action non reconnue: ' . $action]);
        }
        exit;
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => $e->getMessage(), 'trace' => $e->getTraceAsString()]);
        exit;
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(['success' => false, 'error' => 'Erreur base de données: ' . $e->getMessage()]);
        exit;
    }
}

function createRecord($conn, $table, $data) {
    $fields = [];
    $values = [];
    $placeholders = [];
    $hasId = false;
    $servicesToAdd = null;
    
    foreach ($data as $key => $value) {
        if ($key !== 'action' && $key !== 'table') {
            // Gérer les services multiples (pour professionals)
            if ($key === 'services' && $table === 'professionals') {
                $servicesToAdd = $value;
                continue; // Ne pas insérer dans la table principale
            }
            
            // Gérer l'ID : si présent mais vide, générer un ID. Sinon, ignorer le champ ID ici.
            if ($key === 'id') {
                $hasId = true;
                // Si vide, générer un ID. Sinon utiliser la valeur fournie.
                $idValue = empty($value) ? uniqid($table . '_') : $value;
                $fields[] = "`id`";
                $values[':id'] = $idValue;
                $placeholders[] = ':id';
            } else {
                $fields[] = "`$key`";
                $values[":$key"] = $value === '' ? null : $value;
                $placeholders[] = ":$key";
            }
        }
    }
    
    // Si aucun ID n'a été fourni dans les données, en ajouter un
    if (!$hasId) {
        $id = uniqid($table . '_');
        $fields[] = '`id`';
        $values[':id'] = $id;
        $placeholders[] = ':id';
    } else {
        $id = $values[':id'];
    }
    
    $sql = "INSERT INTO `$table` (" . implode(', ', $fields) . ") VALUES (" . implode(', ', $placeholders) . ")";
    $stmt = $conn->prepare($sql);
    $stmt->execute($values);
    
    $insertedId = $id ?? $conn->lastInsertId();
    
    // Si on a des services multiples à ajouter pour un professionnel
    if ($servicesToAdd !== null && $table === 'professionals' && !empty($servicesToAdd)) {
        $serviceIds = explode(',', $servicesToAdd);
        foreach ($serviceIds as $serviceId) {
            $serviceId = trim($serviceId);
            if (!empty($serviceId)) {
                try {
                    $servicesSql = "INSERT INTO professional_services (professional_id, service_id) VALUES (:professional_id, :service_id)";
                    $servicesStmt = $conn->prepare($servicesSql);
                    $servicesStmt->execute([
                        ':professional_id' => $insertedId,
                        ':service_id' => $serviceId
                    ]);
                } catch (PDOException $e) {
                    // Ignorer les doublons (UNIQUE KEY)
                    if (strpos($e->getMessage(), 'Duplicate entry') === false) {
                        error_log("Erreur lors de l'ajout du service $serviceId: " . $e->getMessage());
                    }
                }
            }
        }
    }
    
    return ['success' => true, 'id' => $insertedId];
}

function updateRecord($conn, $table, $data) {
    $id = $data['id'];
    $fields = [];
    $values = [':id' => $id];
    $servicesToUpdate = null;
    
    foreach ($data as $key => $value) {
        if ($key !== 'action' && $key !== 'table' && $key !== 'id') {
            // Gérer les services multiples (pour professionals)
            if ($key === 'services' && $table === 'professionals') {
                $servicesToUpdate = $value;
                continue; // Ne pas mettre à jour dans la table principale
            }
            
            // Pour le password, ignorer s'il est vide (ne pas modifier)
            if ($key === 'password' && empty($value)) {
                continue;
            }
            $fields[] = "`$key` = :$key";
            $values[":$key"] = $value === '' ? null : $value;
        }
    }
    
    if (empty($fields) && $servicesToUpdate === null) {
        return ['success' => false, 'error' => 'Aucun champ à mettre à jour'];
    }
    
    // Mettre à jour les champs de la table principale
    if (!empty($fields)) {
        $sql = "UPDATE `$table` SET " . implode(', ', $fields) . " WHERE `id` = :id";
        $stmt = $conn->prepare($sql);
        $stmt->execute($values);
    }
    
    // Mettre à jour les services multiples
    if ($servicesToUpdate !== null && $table === 'professionals') {
        // Supprimer tous les services existants
        $deleteSql = "DELETE FROM professional_services WHERE professional_id = :professional_id";
        $deleteStmt = $conn->prepare($deleteSql);
        $deleteStmt->execute([':professional_id' => $id]);
        
        // Ajouter les nouveaux services
        if (!empty($servicesToUpdate)) {
            $serviceIds = explode(',', $servicesToUpdate);
            foreach ($serviceIds as $serviceId) {
                $serviceId = trim($serviceId);
                if (!empty($serviceId)) {
                    try {
                        $servicesSql = "INSERT INTO professional_services (professional_id, service_id) VALUES (:professional_id, :service_id)";
                        $servicesStmt = $conn->prepare($servicesSql);
                        $servicesStmt->execute([
                            ':professional_id' => $id,
                            ':service_id' => $serviceId
                        ]);
                    } catch (PDOException $e) {
                        error_log("Erreur lors de la mise à jour du service $serviceId: " . $e->getMessage());
                    }
                }
            }
        }
    }
    
    return ['success' => true];
}

function deleteRecord($conn, $table, $id, $name = null) {
    try {
        // Nettoyer les valeurs
        $id = !empty($id) ? trim($id) : null;
        $name = !empty($name) ? trim($name) : null;
        
        // Si on a un ID, l'utiliser (même s'il est vide, on peut forcer la suppression)
        if (!empty($id)) {
            $sql = "DELETE FROM `$table` WHERE `id` = :id";
            $stmt = $conn->prepare($sql);
            $stmt->execute([':id' => $id]);
            
            if ($stmt->rowCount() > 0) {
                return ['success' => true, 'message' => 'Supprimé par ID'];
            }
        }
        
        // Si l'ID n'a pas fonctionné ou n'existe pas, essayer par nom (pour les services)
        if (!empty($name) && $table === 'services') {
            $sql = "DELETE FROM `$table` WHERE (`name` = :name OR `name_fr` = :name)";
            $stmt = $conn->prepare($sql);
            $stmt->execute([':name' => $name]);
            
            if ($stmt->rowCount() > 0) {
                return ['success' => true, 'message' => 'Supprimé par nom'];
            }
        }
        
        // Si on a un ID vide mais un nom, forcer la suppression pour les services
        if (empty($id) && !empty($name) && $table === 'services') {
            // Essayer de supprimer tous les services avec ce nom
            $sql = "DELETE FROM `$table` WHERE (`name` = :name OR `name_fr` = :name) OR (`id` IS NULL OR `id` = '')";
            $stmt = $conn->prepare($sql);
            $stmt->execute([':name' => $name]);
            
            if ($stmt->rowCount() > 0) {
                return ['success' => true, 'message' => 'Supprimé (service sans ID)'];
            }
        }
        
        // Si aucune méthode n'a fonctionné, essayer de forcer avec WHERE 1=1 pour les services sans ID
        if ($table === 'services' && empty($id)) {
            // Dernière tentative : supprimer par nom exact avec LIKE
            $sql = "DELETE FROM `$table` WHERE (`name` LIKE :name OR `name_fr` LIKE :name) LIMIT 1";
            $stmt = $conn->prepare($sql);
            $stmt->execute([':name' => '%' . $name . '%']);
            
            if ($stmt->rowCount() > 0) {
                return ['success' => true, 'message' => 'Supprimé (recherche par nom)'];
            }
        }
        
        return ['success' => false, 'error' => 'Aucun enregistrement trouvé à supprimer'];
    } catch (PDOException $e) {
        return ['success' => false, 'error' => 'Erreur base de données: ' . $e->getMessage()];
    }
}

function getRecord($conn, $table, $id) {
    $sql = "SELECT * FROM `$table` WHERE `id` = :id";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':id' => $id]);
    $record = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (!$record) {
        return ['success' => false, 'error' => 'Enregistrement non trouvé'];
    }
    
    return ['success' => true, 'data' => $record];
}

function getAllRecords($conn, $table) {
    try {
        $sql = "SELECT * FROM `$table` ORDER BY `id` DESC";
        $stmt = $conn->prepare($sql);
        $stmt->execute();
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        return $results ? $results : [];
    } catch (PDOException $e) {
        error_log("Erreur getAllRecords pour $table: " . $e->getMessage());
        // Retourner un tableau vide en cas d'erreur pour éviter les erreurs fatales
        return [];
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration - Khadma</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f7fa;
            color: #333;
        }
        
        .header {
            background: linear-gradient(135deg, #C1272D 0%, #006233 100%);
            color: white;
            padding: 20px 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 24px;
            font-weight: 600;
        }
        
        .logout-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
            padding: 8px 20px;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.3s;
        }
        
        .logout-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .tab {
            padding: 12px 24px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
            font-size: 14px;
        }
        
        .tab:hover {
            border-color: #C1272D;
            color: #C1272D;
        }
        
        .tab.active {
            background: #C1272D;
            color: white;
            border-color: #C1272D;
        }
        
        .content {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.08);
            padding: 30px;
            min-height: 500px;
        }
        
        .content-section {
            display: none;
        }
        
        .content-section.active {
            display: block;
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .section-header h2 {
            font-size: 24px;
            color: #333;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: #C1272D;
            color: white;
        }
        
        .btn-primary:hover {
            background: #a02026;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(193, 39, 45, 0.3);
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c0392b;
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
        }
        
        .btn-edit {
            background: #3498db;
            color: white;
            padding: 6px 12px;
            font-size: 12px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #f0f0f0;
        }
        
        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #555;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        
        .modal.active {
            display: flex;
        }
        
        .modal-content {
            background: white;
            border-radius: 15px;
            padding: 30px;
            max-width: 600px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .modal-header h3 {
            font-size: 20px;
            color: #333;
        }
        
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #999;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
            font-size: 14px;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #C1272D;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .badge-success {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-danger {
            background: #f8d7da;
            color: #721c24;
        }
        
        .badge-warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state svg {
            width: 80px;
            height: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        /* Styles pour le dropdown de recherche */
        .search-select-container {
            position: relative;
        }
        
        .search-select-input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            background: white;
            cursor: pointer;
        }
        
        .search-select-input:focus {
            outline: none;
            border-color: #C1272D;
        }
        
        .search-select-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 2px solid #e0e0e0;
            border-top: none;
            border-radius: 0 0 8px 8px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        
        .search-select-dropdown.active {
            display: block;
        }
        
        .search-select-option {
            padding: 10px 12px;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .search-select-option:hover {
            background: #f5f5f5;
        }
        
        .search-select-option.selected {
            background: #C1272D;
            color: white;
        }
        
        .search-select-hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>⚙️ Administration Khadma</h1>
        <a href="?logout=1" class="logout-btn">Déconnexion</a>
    </div>
    
    <div class="container">
        <div class="tabs">
            <div class="tab active" data-tab="services">🔧 Services</div>
            <div class="tab" data-tab="professionals">👔 Professionnels</div>
            <div class="tab" data-tab="users">👥 Utilisateurs</div>
        </div>
        
        <div class="content">
            <!-- Services -->
            <div class="content-section active" id="services">
                <?php include 'sections/services.php'; ?>
            </div>
            
            <!-- Professionnels -->
            <div class="content-section" id="professionals">
                <?php include 'sections/professionals.php'; ?>
            </div>
            
            <!-- Utilisateurs -->
            <div class="content-section" id="users">
                <?php include 'sections/users.php'; ?>
            </div>
        </div>
    </div>
    
    <!-- Modal -->
    <div class="modal" id="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modal-title">Ajouter</h3>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            <form id="modal-form">
                <div id="modal-body"></div>
                <div class="form-actions">
                    <button type="button" class="btn" onclick="closeModal()">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Injecter les services disponibles pour le dropdown
        <?php
        $allServices = getAllRecords($conn, 'services');
        ?>
        window.allServices = <?= json_encode($allServices) ?>;
        
        // Gestion des tabs
        document.querySelectorAll('.tab').forEach(tab => {
            tab.addEventListener('click', () => {
                const tabName = tab.dataset.tab;
                
                // Mettre à jour les tabs
                document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                
                // Mettre à jour le contenu
                document.querySelectorAll('.content-section').forEach(section => {
                    section.classList.remove('active');
                });
                document.getElementById(tabName).classList.add('active');
            });
        });
        
        // Fonction pour ouvrir le modal (scope global)
        window.openModal = function(table, action = 'create', id = null) {
            const modal = document.getElementById('modal');
            const modalTitle = document.getElementById('modal-title');
            const modalBody = document.getElementById('modal-body');
            const modalForm = document.getElementById('modal-form');
            
            modalTitle.textContent = action === 'create' ? `Ajouter un ${table}` : `Modifier ${table}`;
            
            // Récupérer les champs selon la table
            const fields = getFieldsForTable(table);
            
            let html = '';
            // Variable pour passer l'action à getFieldHTML
            const currentAction = action;
            fields.forEach(field => {
                // Pour la création, rendre l'ID optionnel (auto-généré si vide)
                if (field.name === 'id' && action === 'create') {
                    html += `
                        <div class="form-group">
                            <label>${field.label} <small style="color: #999;">(optionnel - auto-généré si vide)</small></label>
                            ${getFieldHTML(field, '', currentAction)}
                        </div>
                    `;
                } else if (field.name === 'id' && action === 'update') {
                    // Pour la modification, afficher l'ID en lecture seule
                    html += `
                        <div class="form-group">
                            <label>${field.label}</label>
                            <input type="text" name="${field.name}" value="${id || ''}" readonly style="background: #f5f5f5;">
                        </div>
                    `;
                } else if (field.name !== 'id') {
                    const requiredAttr = field.optional ? '' : '';
                    html += `
                        <div class="form-group">
                            <label>${field.label}${field.optional ? ' <small style="color: #999;">(facultatif)</small>' : ''}</label>
                            ${getFieldHTML(field, '', currentAction)}
                        </div>
                    `;
                }
            });
            
            modalBody.innerHTML = html;
            
            // Initialiser les dropdowns de recherche pour service_id et services (multi)
            if (table === 'professionals') {
                initializeServiceSearch();
            }
            
            // Si c'est une modification, charger les données
            if (action === 'update' && id) {
                loadRecord(table, id);
            }
            
            modalForm.onsubmit = (e) => {
                e.preventDefault();
                window.saveRecord(table, action, id);
            };
            
            modal.classList.add('active');
        };
        
        // Initialiser le dropdown de recherche pour les services
        async function initializeServiceSearch() {
            const searchSelects = document.querySelectorAll('.search-select-container');
            
            searchSelects.forEach(container => {
                const input = container.querySelector('.search-select-input');
                const hidden = container.querySelector('.search-select-hidden');
                const dropdown = container.querySelector('.search-select-dropdown');
                const fieldName = input.dataset.field;
                
                if (fieldName === 'service_id') {
                    // Charger les services
                    loadServicesForDropdown(dropdown, hidden, input);
                    
                    // Gestion de la recherche
                    input.addEventListener('input', (e) => {
                        const query = e.target.value.toLowerCase();
                        filterServiceDropdown(dropdown, query);
                    });
                    
                    // Ouvrir/fermer le dropdown
                    input.addEventListener('focus', () => {
                        dropdown.classList.add('active');
                    });
                    
                    input.addEventListener('blur', () => {
                        // Délai pour permettre le clic sur une option
                        setTimeout(() => {
                            dropdown.classList.remove('active');
                        }, 200);
                    });
                } else if (fieldName === 'services' && input.dataset.multi === 'true') {
                    // Sélection multiple de services
                    const selectedServicesContainer = container.querySelector('.selected-services');
                    const hiddenMulti = container.querySelector('.search-select-hidden-multi');
                    
                    loadServicesForMultiSelect(dropdown, hiddenMulti, input, selectedServicesContainer);
                    
                    // Gestion de la recherche
                    input.addEventListener('input', (e) => {
                        const query = e.target.value.toLowerCase();
                        filterServiceDropdown(dropdown, query);
                    });
                    
                    // Ouvrir/fermer le dropdown
                    input.addEventListener('focus', () => {
                        dropdown.classList.add('active');
                    });
                    
                    input.addEventListener('blur', () => {
                        setTimeout(() => {
                            dropdown.classList.remove('active');
                        }, 200);
                    });
                }
            });
        }
        
        // Charger les services dans le dropdown
        function loadServicesForDropdown(dropdown, hidden, input) {
            const services = window.allServices || [];
            
            dropdown.innerHTML = '';
            
            services.forEach(service => {
                const option = document.createElement('div');
                option.className = 'search-select-option';
                const serviceLabel = service.name_fr ? `${service.name_fr} (${service.name || ''})` : (service.name || 'Sans nom');
                option.textContent = serviceLabel;
                option.dataset.value = service.id;
                option.dataset.label = serviceLabel;
                
                option.addEventListener('click', () => {
                    hidden.value = service.id;
                    input.value = option.dataset.label;
                    dropdown.classList.remove('active');
                    
                    // Marquer comme sélectionné
                    dropdown.querySelectorAll('.search-select-option').forEach(opt => {
                        opt.classList.remove('selected');
                    });
                    option.classList.add('selected');
                });
                
                dropdown.appendChild(option);
            });
            
            // Si une valeur est déjà présente, la pré-sélectionner
            if (hidden.value) {
                const selectedService = services.find(s => s.id === hidden.value);
                if (selectedService) {
                    const serviceLabel = selectedService.name_fr ? `${selectedService.name_fr} (${selectedService.name || ''})` : (selectedService.name || 'Sans nom');
                    input.value = serviceLabel;
                    
                    // Marquer l'option comme sélectionnée
                    dropdown.querySelectorAll('.search-select-option').forEach(opt => {
                        opt.classList.remove('selected');
                        if (opt.dataset.value === selectedService.id) {
                            opt.classList.add('selected');
                        }
                    });
                }
            }
        }
        
        // Charger les services pour sélection multiple
        function loadServicesForMultiSelect(dropdown, hidden, input, selectedContainer) {
            const services = window.allServices || [];
            
            dropdown.innerHTML = '';
            
            services.forEach(service => {
                const option = document.createElement('div');
                option.className = 'search-select-option';
                const serviceLabel = service.name_fr ? `${service.name_fr} (${service.name || ''})` : (service.name || 'Sans nom');
                option.textContent = serviceLabel;
                option.dataset.value = service.id;
                option.dataset.label = serviceLabel;
                
                option.addEventListener('click', () => {
                    // Ajouter le service s'il n'est pas déjà sélectionné
                    const currentValues = hidden.value ? hidden.value.split(',') : [];
                    if (!currentValues.includes(service.id)) {
                        currentValues.push(service.id);
                        hidden.value = currentValues.join(',');
                        
                        // Afficher le badge du service sélectionné
                        const badge = document.createElement('span');
                        badge.className = 'selected-service-badge';
                        badge.style.cssText = 'display: inline-flex; align-items: center; padding: 4px 12px; background: #C1272D; color: white; border-radius: 16px; font-size: 12px; margin: 4px;';
                        badge.innerHTML = `${serviceLabel} <span style="margin-left: 8px; cursor: pointer;" onclick="removeService('${service.id}', this, '${hidden.dataset.field}')">×</span>`;
                        badge.dataset.serviceId = service.id;
                        selectedContainer.appendChild(badge);
                    }
                    
                    // Réinitialiser l'input
                    input.value = '';
                    dropdown.classList.remove('active');
                });
                
                dropdown.appendChild(option);
            });
            
            // Charger les services déjà sélectionnés
            if (hidden.value) {
                const selectedIds = hidden.value.split(',');
                selectedIds.forEach(serviceId => {
                    if (serviceId) {
                        const service = services.find(s => s.id === serviceId);
                        if (service) {
                            const serviceLabel = service.name_fr ? `${service.name_fr} (${service.name || ''})` : (service.name || 'Sans nom');
                            const badge = document.createElement('span');
                            badge.className = 'selected-service-badge';
                            badge.style.cssText = 'display: inline-flex; align-items: center; padding: 4px 12px; background: #C1272D; color: white; border-radius: 16px; font-size: 12px; margin: 4px;';
                            badge.innerHTML = `${serviceLabel} <span style="margin-left: 8px; cursor: pointer;" onclick="removeService('${service.id}', this, '${hidden.dataset.field}')">×</span>`;
                            badge.dataset.serviceId = service.id;
                            selectedContainer.appendChild(badge);
                        }
                    }
                });
            }
        }
        
        // Fonction pour supprimer un service de la sélection multiple
        window.removeService = function(serviceId, element, fieldName) {
            const container = document.querySelector(`.selected-services[data-field="${fieldName}"]`);
            const hidden = document.querySelector(`.search-select-hidden-multi[data-field="${fieldName}"]`);
            const badge = element.closest('.selected-service-badge');
            
            if (badge && hidden) {
                const currentValues = hidden.value ? hidden.value.split(',').filter(id => id !== serviceId) : [];
                hidden.value = currentValues.join(',');
                badge.remove();
            }
        };
        
        // Filtrer le dropdown selon la recherche
        function filterServiceDropdown(dropdown, query) {
            const options = dropdown.querySelectorAll('.search-select-option');
            options.forEach(option => {
                const text = option.textContent.toLowerCase();
                if (text.includes(query)) {
                    option.style.display = 'block';
                } else {
                    option.style.display = 'none';
                }
            });
        }
        
        window.closeModal = function() {
            document.getElementById('modal').classList.remove('active');
        }
        
        function getFieldsForTable(table) {
            const fields = {
                services: [
                    {name: 'id', label: 'ID'},
                    {name: 'name', label: 'Nom'},
                    {name: 'name_fr', label: 'Nom (FR)'},
                    {name: 'name_ar', label: 'Nom (AR)'},
                    {name: 'name_darija', label: 'Nom (Darija)'},
                    {name: 'category_id', label: 'Catégorie', type: 'select'},
                    {name: 'icon', label: 'Icône (Emoji)'},
                    {name: 'description', label: 'Description', type: 'textarea'},
                    {name: 'color', label: 'Couleur (Hex)', type: 'color'},
                    {name: 'is_active', label: 'Actif', type: 'checkbox'}
                ],
                professionals: [
                    {name: 'id', label: 'ID'},
                    {name: 'email', label: 'Email', type: 'email'},
                    {name: 'password', label: 'Mot de passe', type: 'password'},
                    {name: 'first_name', label: 'Prénom'},
                    {name: 'last_name', label: 'Nom'},
                    {name: 'phone', label: 'Téléphone'},
                    {name: 'business_name', label: 'Nom d\'entreprise', optional: true},
                    {name: 'services', label: 'Services (plusieurs)', type: 'multi_search_select'},
                    {name: 'service_id', label: 'Service Principal', type: 'search_select', optional: true},
                    {name: 'city', label: 'Ville'},
                    {name: 'district', label: 'Quartier'},
                    {name: 'address', label: 'Adresse', type: 'textarea'},
                    {name: 'location', label: 'Localisation'},
                    {name: 'description', label: 'Description', type: 'textarea'},
                    {name: 'base_price', label: 'Prix de base', type: 'number'},
                    {name: 'certification_number', label: 'Numéro de certification'},
                    {name: 'tax_id', label: 'Numéro fiscal'},
                    {name: 'status', label: 'Statut', type: 'select', options: ['pending', 'verified', 'rejected', 'suspended']},
                    {name: 'is_available', label: 'Disponible', type: 'checkbox'}
                ],
                users: [
                    {name: 'id', label: 'ID'},
                    {name: 'email', label: 'Email', type: 'email'},
                    {name: 'password', label: 'Mot de passe', type: 'password'},
                    {name: 'first_name', label: 'Prénom'},
                    {name: 'last_name', label: 'Nom'},
                    {name: 'phone', label: 'Téléphone'},
                    {name: 'is_guest', label: 'Invité', type: 'checkbox'},
                    {name: 'is_active', label: 'Actif', type: 'checkbox'}
                ]
            };
            
            return fields[table] || [];
        }
        
        function getFieldHTML(field, value, action = 'create') {
            switch(field.type) {
                case 'textarea':
                    const textareaRequired = field.optional ? '' : 'required';
                    return `<textarea name="${field.name}" ${textareaRequired}>${value}</textarea>`;
                case 'select':
                    if (field.name === 'category_id') {
                        return `<select name="${field.name}"><option value="">Aucune</option></select>`;
                    }
                    if (field.options) {
                        let options = field.options.map(opt => 
                            `<option value="${opt}" ${value === opt ? 'selected' : ''}>${opt}</option>`
                        ).join('');
                        return `<select name="${field.name}">${options}</select>`;
                    }
                    return `<select name="${field.name}"></select>`;
                case 'search_select':
                    // Créer un dropdown de recherche pour les services
                    return `
                        <div class="search-select-container">
                            <input type="text" class="search-select-input" placeholder="Rechercher un service..." autocomplete="off" data-field="${field.name}">
                            <input type="hidden" name="${field.name}" value="${value || ''}" class="search-select-hidden">
                            <div class="search-select-dropdown" data-field="${field.name}"></div>
                        </div>
                    `;
                case 'multi_search_select':
                    // Créer un dropdown de recherche multiple pour les services
                    return `
                        <div class="search-select-container">
                            <input type="text" class="search-select-input" placeholder="Rechercher et sélectionner plusieurs services..." autocomplete="off" data-field="${field.name}" data-multi="true">
                            <div class="selected-services" data-field="${field.name}" style="margin-top: 8px; display: flex; flex-wrap: wrap; gap: 8px;"></div>
                            <input type="hidden" name="${field.name}" value="${value || ''}" class="search-select-hidden-multi" data-field="${field.name}">
                            <div class="search-select-dropdown" data-field="${field.name}"></div>
                        </div>
                    `;
                case 'checkbox':
                    return `<input type="checkbox" name="${field.name}" ${value ? 'checked' : ''}>`;
                case 'color':
                    return `<input type="color" name="${field.name}" value="${value || '#2196F3'}">`;
                case 'number':
                    const numberRequired = field.optional ? '' : 'required';
                    return `<input type="number" name="${field.name}" step="0.01" value="${value}" ${numberRequired}>`;
                case 'email':
                    return `<input type="email" name="${field.name}" value="${value}" required>`;
                case 'password':
                    // Ne pas rendre le mot de passe obligatoire en modification
                    const passwordPlaceholder = action === 'update' ? 'Laisser vide pour ne pas modifier' : 'Mot de passe';
                    const passwordRequired = action === 'create' ? 'required' : '';
                    return `<input type="password" name="${field.name}" placeholder="${passwordPlaceholder}" ${passwordRequired}>`;
                default:
                    // Rendre tous les champs obligatoires sauf si spécifié autrement
                    const required = (field.name === 'id' || field.optional) ? '' : 'required';
                    return `<input type="text" name="${field.name}" value="${value}" ${required}>`;
            }
        }
        
        window.loadRecord = async function(table, id) {
            const formData = new FormData();
            formData.append('action', 'get');
            formData.append('table', table);
            formData.append('id', id);
            
            try {
                const response = await fetch(window.location.href, {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                
                if (result.success) {
                    const data = result.data;
                    document.querySelectorAll('#modal-form input, #modal-form textarea, #modal-form select').forEach(input => {
                        if (input.type === 'checkbox') {
                            input.checked = data[input.name] == 1 || data[input.name] === true;
                        } else if (input.classList.contains('search-select-hidden')) {
                            // Pour les champs cachés de recherche, mettre la valeur et mettre à jour l'input visible
                            input.value = data[input.name] || '';
                            const visibleInput = input.parentElement.querySelector('.search-select-input');
                            const dropdown = input.parentElement.querySelector('.search-select-dropdown');
                            if (visibleInput && dropdown) {
                                loadServicesForDropdown(dropdown, input, visibleInput);
                            }
                        } else if (input.classList.contains('search-select-hidden-multi')) {
                            // Pour les champs de sélection multiple, charger les services depuis l'API
                            loadProfessionalServices(data.id, input);
                        } else if (!input.classList.contains('search-select-input')) {
                            // Ignorer les inputs de recherche visibles (ils seront mis à jour via loadServicesForDropdown)
                            input.value = data[input.name] || '';
                        }
                    });
                    
                    // Réinitialiser les dropdowns de recherche après chargement
                    if (table === 'professionals') {
                        setTimeout(() => {
                            initializeServiceSearch();
                        }, 100);
                    }
                }
            } catch (error) {
                console.error('Erreur:', error);
                alert('Erreur lors du chargement: ' + error.message);
            }
        };
        
        window.saveRecord = async function(table, action, id) {
            const formData = new FormData(document.getElementById('modal-form'));
            formData.append('action', action);
            formData.append('table', table);
            if (id) formData.append('id', id);
            
            // Gérer les checkboxes
            document.querySelectorAll('#modal-form input[type="checkbox"]').forEach(checkbox => {
                formData.set(checkbox.name, checkbox.checked ? '1' : '0');
            });
            
            // Ne pas envoyer le password vide en modification
            const passwordInput = document.querySelector('input[name="password"]');
            if (passwordInput && action === 'update' && !passwordInput.value.trim()) {
                formData.delete('password');
            }
            
            try {
                const response = await fetch(window.location.href, {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                
                if (result.success) {
                    alert('Enregistré avec succès!');
                    window.closeModal();
                    location.reload();
                } else {
                    alert('Erreur: ' + (result.error || 'Erreur inconnue'));
                }
            } catch (error) {
                console.error('Erreur:', error);
                alert('Erreur: ' + error.message);
            }
        };
        
        window.deleteRecord = async function(table, id) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer cet élément ?')) return;
            
            const formData = new FormData();
            formData.append('action', 'delete');
            formData.append('table', table);
            if (id) {
                formData.append('id', id);
            }
            
            try {
                const response = await fetch(window.location.href, {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                
                if (result.success) {
                    alert('Supprimé avec succès!');
                    location.reload();
                } else {
                    alert('Erreur: ' + (result.error || 'Erreur inconnue'));
                }
            } catch (error) {
                console.error('Erreur:', error);
                alert('Erreur: ' + error.message);
            }
        };
        
        // Fonction spécifique pour supprimer un service (gère les cas sans ID)
        window.deleteServiceRecord = async function(id, name) {
            if (!confirm('Êtes-vous sûr de vouloir supprimer ce service ?')) return;
            
            const formData = new FormData();
            formData.append('action', 'delete');
            formData.append('table', 'services');
            if (id && id.trim() !== '') {
                formData.append('id', id);
            } else if (name) {
                formData.append('name', name);
            } else {
                alert('Impossible de supprimer : ID et nom manquants');
                return;
            }
            
            try {
                const response = await fetch(window.location.href, {
                    method: 'POST',
                    body: formData
                });
                const result = await response.json();
                
                if (result.success) {
                    alert('Service supprimé avec succès!');
                    location.reload();
                } else {
                    alert('Erreur: ' + (result.error || 'Erreur inconnue'));
                }
            } catch (error) {
                console.error('Erreur:', error);
                alert('Erreur: ' + error.message);
            }
        };
        
        // Charger les services d'un professionnel pour la sélection multiple
        async function loadProfessionalServices(professionalId, hiddenInput) {
            try {
                const response = await fetch(`../api/get_professionals.php?id=${professionalId}`);
                const result = await response.json();
                
                if (result.success && result.data && result.data.length > 0) {
                    const professional = result.data[0];
                    if (professional.services && professional.services.length > 0) {
                        // Récupérer les IDs des services depuis leur nom
                        const allServices = window.allServices || [];
                        const serviceIds = [];
                        
                        professional.services.forEach(serviceName => {
                            const service = allServices.find(s => 
                                s.name === serviceName || s.name_fr === serviceName
                            );
                            if (service) {
                                serviceIds.push(service.id);
                            }
                        });
                        
                        if (serviceIds.length > 0) {
                            hiddenInput.value = serviceIds.join(',');
                            
                            // Mettre à jour l'affichage des badges
                            const container = document.querySelector(`.selected-services[data-field="${hiddenInput.dataset.field}"]`);
                            if (container) {
                                container.innerHTML = '';
                                const dropdown = container.parentElement.querySelector('.search-select-dropdown');
                                if (dropdown) {
                                    loadServicesForMultiSelect(dropdown, hiddenInput, 
                                        container.parentElement.querySelector('.search-select-input'), container);
                                }
                            }
                        }
                    }
                }
            } catch (error) {
                console.error('Erreur lors du chargement des services:', error);
            }
        }
        
        // Logout
        <?php if (isset($_GET['logout'])): ?>
            <?php session_destroy(); header('Location: admin.php'); exit; ?>
        <?php endif; ?>
    </script>
</body>
</html>
