<?php
header('Content-Type: application/json');

require 'db.php'; // Asegúrate de incluir la conexión a la base de datos

$method = $_SERVER['REQUEST_METHOD'];
$segments = explode('/', trim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/'));

try {
    switch ($method) {
        case 'GET':
            if (isset($segments[2]) && $segments[2] === 'involucrados' && isset($_GET['id_usuario'])) {
                // Consulta para obtener usuarios involucrados en mensajes con iniciales
                $id_usuario = intval($_GET['id_usuario']);
                $stmt = $pdo->prepare("
                    WITH usuarios_mensajes AS (
                        SELECT 
                            u.id_usuario, 
                            u.usuario_usuario,
                            u.nombre_usuario, 
                            u.apellido_paterno_usuario, 
                            u.rol_usuario, 
                            u.genero_usuario,
                            LEFT(u.nombre_usuario, 1) AS nombre_inicial,
                            LEFT(u.apellido_paterno_usuario, 1) AS apellido_inicial,
                            m.fecha_creacion_mensaje,
                            ROW_NUMBER() OVER (
                                PARTITION BY u.id_usuario 
                                ORDER BY m.fecha_creacion_mensaje DESC
                            ) AS rn
                        FROM usuarios u
                        JOIN mensajes m 
                            ON (u.id_usuario = m.id_remitente_mensaje 
                            OR u.id_usuario = m.id_destinatario_mensaje)
                        WHERE (m.id_remitente_mensaje = :id 
                            OR m.id_destinatario_mensaje = :id) 
                        AND u.id_usuario != :id
                    )
                    SELECT 
                        id_usuario, 
                        nombre_usuario, 
                        apellido_paterno_usuario, 
                        rol_usuario, 
                        genero_usuario,
                        nombre_inicial,
                        apellido_inicial
                    FROM usuarios_mensajes
                    WHERE rn = 1
                    ORDER BY fecha_creacion_mensaje DESC;
                ");
                $stmt->execute(['id' => $id_usuario]);
                $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

                echo json_encode($users);
                exit();
            } elseif (isset($segments[2]) && $segments[2] === 'excepto' && isset($_GET['id_usuario'])) {
                // Consulta para obtener todos los usuarios excepto uno específico con iniciales
                $id_usuario = intval($_GET['id_usuario']);
                $stmt = $pdo->prepare("
                    SELECT 
                        u.id_usuario, 
                        u.nombre_usuario, 
                        u.apellido_paterno_usuario, 
                        u.rol_usuario, 
                        u.genero_usuario,
                        LEFT(u.nombre_usuario, 1) AS nombre_inicial,
                        LEFT(u.apellido_paterno_usuario, 1) AS apellido_inicial
                    FROM usuarios u
                    WHERE u.id_usuario != :id
                ");
                $stmt->execute(['id' => $id_usuario]);
                $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

                echo json_encode($users);
                exit();
            } elseif (isset($segments[1]) && $segments[1] === 'usuarios' && isset($_GET['id_usuario'])) {
                // Consulta para obtener el nombre de usuario por ID
                $id_usuario = intval($_GET['id_usuario']);
                $stmt = $pdo->prepare("SELECT nombre_usuario FROM usuarios WHERE id_usuario = ?");
                $stmt->execute([$id_usuario]);
                $result = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($result) {
                    echo json_encode($result);
                } else {
                    header("HTTP/1.1 404 Not Found");
                    echo json_encode(['message' => 'Usuario no encontrado']);
                }
                exit();
            } else {
                // Obtener todos los usuarios con iniciales
                $stmt = $pdo->query("
                    SELECT 
                        id_usuario, 
                        nombre_usuario, 
                        apellido_paterno_usuario,
                        usuario_usuario,
                        rol_usuario, 
                        genero_usuario,
                        LEFT(nombre_usuario, 1) AS nombre_inicial,
                        LEFT(apellido_paterno_usuario, 1) AS apellido_inicial
                    FROM usuarios
                ");
                $users = $stmt->fetchAll(PDO::FETCH_ASSOC);

                echo json_encode($users);
                exit();
            }
            break;

        case 'POST':
            $data = json_decode(file_get_contents('php://input'), true);

            if (isset($data['nombre_usuario']) && isset($data['apellido_paterno_usuario']) && 
                isset($data['apellido_materno_usuario']) && isset($data['correo_usuario']) &&
                isset($data['telefono_usuario']) && isset($data['rol_usuario']) &&
                isset($data['genero_usuario']) && isset($data['usuario_usuario']) &&
                isset($data['contraseña_usuario'])) {

                $passwordHash = password_hash($data['contraseña_usuario'], PASSWORD_BCRYPT);
                $stmt = $pdo->prepare("INSERT INTO usuarios (nombre_usuario, apellido_paterno_usuario, apellido_materno_usuario, correo_usuario, telefono_usuario, rol_usuario, genero_usuario, usuario_usuario, contraseña_usuario, fecha_creacion_usuario, fecha_modificacion_usuario) 
                                        VALUES (:nombre, :apellido_paterno, :apellido_materno, :correo, :telefono, :rol, :genero, :usuario, :contraseña, NOW(), NOW())");

                $stmt->execute([
                    'nombre' => $data['nombre_usuario'],
                    'apellido_paterno' => $data['apellido_paterno_usuario'],
                    'apellido_materno' => $data['apellido_materno_usuario'],
                    'correo' => $data['correo_usuario'],
                    'telefono' => $data['telefono_usuario'],
                    'rol' => $data['rol_usuario'],
                    'genero' => $data['genero_usuario'],
                    'usuario' => $data['usuario_usuario'],
                    'contraseña' => $passwordHash
                ]);

                echo json_encode(['message' => 'Usuario creado']);
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
