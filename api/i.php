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
            // Manejar la subida de fotos
            if ($segments[0] == 'upload_photo') {
                $targetDir = "uploads/";
                $targetFile = $targetDir . basename($_FILES["photo"]["name"]);
                move_uploaded_file($_FILES["photo"]["tmp_name"], $targetFile);

                echo json_encode(['photo_url' => $targetFile]);
                exit();
            }

            // Manejar detalles de inspección
            if (isset($data['id_inspeccion_detalle']) && isset($data['item_detalle']) && isset($data['aprobado_detalle'])) {
                $stmt = $pdo->prepare("INSERT INTO detalles_inspeccion (id_inspeccion_detalle, item_detalle, aprobado_detalle, foto_evidencia_detalle, comentarios_detalle, fecha_creacion_detalle, fecha_modificacion_detalle) VALUES (?, ?, ?, ?, ?, NOW(), NULL)");
                $stmt->execute([
                    $data['id_inspeccion_detalle'],
                    $data['item_detalle'],
                    $data['aprobado_detalle'],
                    $data['foto_evidencia_detalle'],
                    $data['comentarios_detalle'],
                    $data['inspeccion_detalle']
                ]);

                echo json_encode(['message' => 'Detalle de inspección creado']);
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