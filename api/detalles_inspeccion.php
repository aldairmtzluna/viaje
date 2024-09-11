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
         if (isset($_GET['id_detalle']) && is_numeric($_GET['id_detalle'])) {
            // Obtener inspecciones por ID
            $id = intval($_GET['id_detalle']);
            $stmt = $pdo->prepare("SELECT * FROM detalles_inspeccion WHERE id_detalle = ?");
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
                // Obtener todos los detalles de las inspecciones
                $stmt = $pdo->query("SELECT * FROM detalles_inspeccion");
                $trips = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($trips);
                exit();
         }
        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);

            if (isset($data['id_inspeccion_detalle']) && isset($data['item_detalle']) && isset($data['aprobado_detalle']) && isset($data['foto_evidencia_detalle']) && isset($data['comentarios_detalle'])) {
                
                $stmt = $pdo->prepare("INSERT INTO detalles_inspeccion (id_inspeccion_detalle, item_detalle, aprobado_detalle, foto_evidencia_detalle, comentarios_detalle, fecha_creacion_detalle, fecha_modificacion_detalle) VALUES (?, ?, ?, ?, ?, NOW(), NULL)");

                $stmt->execute([
                    $data['id_inspeccion_detalle'],
                    $data['item_detalle'],
                    $data['aprobado_detalle'],
                    $data['foto_evidencia_detalle'],
                    $data['comentarios_detalle']
                ]);

                echo json_encode(['message' => 'Detalle de inspección creada']);
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