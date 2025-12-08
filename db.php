<?php
// db.php

$host = "localhost"; // Modifiez si nécessaire
$db_name = "u958443732_afopeq"; // Remplacez par le nom de votre base de données
$username = "u958443732_afopeq"; // Remplacez par votre nom d'utilisateur
$password = "Afopeq02@"; // Remplacez par votre mot de passe

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // Définir le charset UTF-8
    $conn->exec("set names utf8mb4");
} catch(PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    exit; // Arrêtez le script si la connexion échoue
}
?>
