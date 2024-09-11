<?php
header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);

if (isset($data['usuario_usuario']) && isset($data['contraseña_usuario'])) {
    $usuario = $data['usuario_usuario'];
    $contraseña = $data['contraseña_usuario'];

    $stmt = $pdo->prepare("SELECT * FROM usuarios WHERE usuario_usuario = :usuario");
    $stmt->execute(['usuario' => $usuario]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && $user['contraseña_usuario'] === $contraseña) {
        echo json_encode([
            'id_usuario' => $user['id_usuario'],
            'nombre_usuario' => $user['nombre_usuario'],
            'apellido_paterno_usuario' => $user['apellido_paterno_usuario'],
            'apellido_materno_usuario' => $user['apellido_materno_usuario'],
            'correo_usuario' => $user['correo_usuario'],
            'telefono_usuario' => $user['telefono_usuario'],
            'rol_usuario' => $user['rol_usuario'],
            'genero_usuario' => $user['genero_usuario'],
            'fecha_creacion_usuario' => $user['fecha_creacion_usuario'],
            'fecha_modificacion_usuario' => $user['fecha_modificacion_usuario'],
            'id_flotilla_usuarios' => $user['id_flotilla_usuarios']
        ]);
    } else {
        header("HTTP/1.1 401 Unauthorized");
        echo json_encode(['message' => 'Invalid credentials']);
    }
} else {
    header("HTTP/1.1 400 Bad Request");
    echo json_encode(['message' => 'Invalid input']);
}
?>
