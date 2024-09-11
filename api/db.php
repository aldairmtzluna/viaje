<?php
$host = "srv992.hstgr.io";
$db = "u663124265_vje";
$user = "u663124265_vje";
$pass = "9k:9zv1ISD+C";

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Tu código para interactuar con la base de datos aquí
    
} catch (PDOException $e) {
    echo 'Connection failed: ' . $e->getMessage();
}
?>
