<?php
header('Content-Type: application/json');

require 'db.php'; 

$method = $_SERVER['REQUEST_METHOD'];
$request = $_SERVER['REQUEST_URI'];
$path = parse_url($request, PHP_URL_PATH);
$segments = explode('/', trim($path, '/'));

try {
    switch ($method) {
        case 'GET':
         if (isset($_GET['id_flotilla']) && is_numeric($_GET['id_flotilla'])) {
            // Obtener flotilla por ID
            $id = intval($_GET['id_flotilla']);
            $stmt = $pdo->prepare("SELECT * FROM flotillas WHERE id_flotilla = ?");
            $stmt->execute([$id]);
            $trip = $stmt->fetch(PDO::FETCH_ASSOC);
        
            if ($trip) {
                echo json_encode($trip);
            } else {
                header("HTTP/1.1 404 Not Found");
                echo json_encode(['message' => 'Flotilla no encontrada']);
            }
            exit();
         }else {
                // Obtener todas las flotillas
                $stmt = $pdo->query("SELECT * FROM flotillas");
                $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($trips);
                exit();
         }
    }
}catch (PDOException $e) {
    header("HTTP/1.1 500 Internal Server Error");
    echo json_encode(['message' => 'Error en el servidor', 'error' => $e->getMessage()]);
    exit();
}

// Cierra la conexión
$pdo = null;
?>