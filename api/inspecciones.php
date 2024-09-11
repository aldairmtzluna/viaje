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
         if (isset($_GET['id_inspeccion']) && is_numeric($_GET['id_inspeccion'])) {
            // Obtener inspecciones por ID
            $id = intval($_GET['id_inspeccion']);
            $stmt = $pdo->prepare("SELECT * FROM inspecciones WHERE id_inspeccion = ?");
            $stmt->execute([$id]);
            $trip = $stmt->fetch(PDO::FETCH_ASSOC);
        
            if ($trip) {
                echo json_encode($trip);
            } else {
                header("HTTP/1.1 404 Not Found");
                echo json_encode(['message' => 'Inspección no encontrada']);
            }
            exit();
         }else {
                // Obtener todos las inspecciones
                $stmt = $pdo->query("SELECT * FROM inspecciones");
                $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($trips);
                exit();
         }
        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);

            if (isset($data['estado_inspeccion']) && isset($data['id_unidad_inspeccion']) && isset($data['id_conductor_inspeccion'])) {
                
                $stmt = $pdo->prepare("INSERT INTO inspecciones (fecha_inspeccion, estado_inspeccion, id_unidad_inspeccion, id_conductor_inspeccion, fecha_creacion_inspeccion, fecha_modificacion_inspeccion) VALUES (NOW(), ?, ?, ?, NOW(), NULL)");

                $stmt->execute([
                    $data['estado_inspeccion'],
                    $data['id_unidad_inspeccion'],
                    $data['id_conductor_inspeccion'],
                ]);

                echo json_encode(['message' => 'inspección creada']);
                exit();
            } else {
                header("HTTP/1.1 400 Bad Request");
                echo json_encode(['message' => 'Datos inválidos']);
                exit();
            }
            break;
    }
}catch (PDOException $e) {
    header("HTTP/1.1 500 Internal Server Error");
    echo json_encode(['message' => 'Error en el servidor', 'error' => $e->getMessage()]);
    exit();
}

// Cierra la conexión
$pdo = null;
?>