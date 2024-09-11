<?php
require 'db.php';

$method = $_SERVER['REQUEST_METHOD'];

// Verifica si la petición es GET
if ($method === 'GET') {
    // Extrae el parámetro 'id_usuario_conductor' de la URL si está presente
    if (isset($_GET['id_conductor_unidad'])) {
        $id_conductor_unidad = $_GET['id_conductor_unidad'];

        // Preparar la segunda consulta
        $sql = "SELECT u.placa_unidad, us.id_usuario
                FROM unidades u
                INNER JOIN usuarios us ON u.id_usuario_unidad = us.id_usuario
                WHERE u.id_usuario_unidad = :id_conductor_unidad";

        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':id_conductor_unidad', $id_conductor_unidad, PDO::PARAM_INT);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($result);
    } else {
        // Ejecutar la primera consulta
        $sql = "SELECT * FROM unidades";
        $stmt = $pdo->query($sql);
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($result);
    }
} else {
    // Si el método no es GET, devolver un error 405 Method Not Allowed
    header("HTTP/1.1 405 Method Not Allowed");
    echo json_encode(['message' => 'Método no permitido']);
}
?>
