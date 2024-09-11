<?php
header('Content-Type: application/json');

require 'db.php'; // Asegúrate de incluir la conexión a la base de datos

$method = $_SERVER['REQUEST_METHOD'];
$request = $_SERVER['REQUEST_URI'];
$path = parse_url($request, PHP_URL_PATH);
$segments = explode('/', trim($path, '/'));

try {
    switch ($method) {
        case 'GET':
            if (isset($_GET['id_mensaje']) && is_numeric($_GET['id_mensaje'])) {
                // Obtener mensaje por ID
                $id = intval($_GET['id_mensaje']);
                $stmt = $pdo->prepare("SELECT * FROM mensajes WHERE id_mensaje = ?");
                $stmt->execute([$id]);
                $message = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($message) {
                    echo json_encode($message);
                } else {
                    header("HTTP/1.1 404 Not Found");
                    echo json_encode(['message' => 'Mensaje no encontrado']);
                }
                exit();
            } elseif (isset($_GET['usuario_uno']) && isset($_GET['usuario_dos'])) {
                // Obtener mensajes entre dos usuarios
                $usuarioUno = intval($_GET['usuario_uno']);
                $usuarioDos = intval($_GET['usuario_dos']);
                $stmt = $pdo->prepare(
                    "SELECT * FROM mensajes WHERE 
                    (id_remitente_mensaje = ? AND id_destinatario_mensaje = ?) 
                    OR (id_remitente_mensaje = ? AND id_destinatario_mensaje = ?)
                    ORDER BY fecha_creacion_mensaje ASC"
                );
                $stmt->execute([$usuarioUno, $usuarioDos, $usuarioDos, $usuarioUno]);
                $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

                if ($messages) {
                    echo json_encode($messages);
                } else {
                    header("HTTP/1.1 404 Not Found");
                    echo json_encode(['message' => 'No se encontraron mensajes']);
                }
                exit();
            } else {
                // Obtener todos los mensajes
                $stmt = $pdo->query("SELECT * FROM mensajes");
                $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($messages);
                exit();
            }
            break;

        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);

            if (isset($data['id_remitente_mensaje']) && isset($data['id_destinatario_mensaje']) && isset($data['contenido_mensaje'])) {
                $stmt = $pdo->prepare("INSERT INTO mensajes (id_remitente_mensaje, id_destinatario_mensaje, contenido_mensaje, adjuntos_mensaje, fecha_creacion_mensaje, fecha_modificacion_mensaje) 
                                        VALUES (?, ?, ?, ?, NOW(), NULL)");

                $stmt->execute([
                    $data['id_remitente_mensaje'],
                    $data['id_destinatario_mensaje'],
                    $data['contenido_mensaje'],
                    $data['adjuntos_mensaje'] ?? null,
                ]);

                echo json_encode(['message' => 'Mensaje creado']);
                exit();
            } else {
                header("HTTP/1.1 400 Bad Request");
                echo json_encode(['message' => 'Datos inválidos']);
                exit();
            }
            break;

        case 'PUT':
            $data = json_decode(file_get_contents('php://input'), true);

            if (isset($data['id_mensaje']) && isset($data['contenido_mensaje'])) {
                $stmt = $pdo->prepare("UPDATE mensajes 
                                    SET contenido_mensaje = ?, 
                                        fecha_modificacion_mensaje = NOW() 
                                    WHERE id_mensaje = ?");
                $stmt->execute([$data['contenido_mensaje'], $data['id_mensaje']]);
                
                if ($stmt->rowCount() > 0) {
                    echo json_encode(['message' => 'Mensaje actualizado']);
                } else {
                    header("HTTP/1.1 404 Not Found");
                    echo json_encode(['message' => 'Mensaje no encontrado']);
                }
                exit();
            } else {
                header("HTTP/1.1 400 Bad Request");
                echo json_encode(['message' => 'Datos inválidos']);
                exit();
            }
            break;

        case 'DELETE':
            if (isset($_GET['id_mensaje']) && is_numeric($_GET['id_mensaje'])) {
                $id = intval($_GET['id_mensaje']);
                $stmt = $pdo->prepare("DELETE FROM mensajes WHERE id_mensaje = ?");
                $stmt->execute([$id]);

                if ($stmt->rowCount() > 0) {
                    echo json_encode(['message' => 'Mensaje eliminado']);
                } else {
                    header("HTTP/1.1 404 Not Found");
                    echo json_encode(['message' => 'Mensaje no encontrado']);
                }
                exit();
            } else {
                header("HTTP/1.1 400 Bad Request");
                echo json_encode(['message' => 'Datos inválidos']);
                exit();
            }
            break;

        default:
            header("HTTP/1.1 405 Method Not Allowed");
            echo json_encode(['message' => 'Método no permitido']);
            exit();
            break;
    }
} catch (PDOException $e) {
    header("HTTP/1.1 500 Internal Server Error");
    echo json_encode(['message' => 'Error en el servidor', 'error' => $e->getMessage()]);
    exit();
}

// Cierra la conexión
$pdo = null;
?>
