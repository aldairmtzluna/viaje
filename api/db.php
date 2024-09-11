<?php
$host = "";
$db = "";
$user = "";
$pass = "";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Tu código para interactuar con la base de datos aquí
    
} catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
}
?>
