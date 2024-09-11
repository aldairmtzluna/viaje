<?php
require 'db.php';

$method = $_SERVER['REQUEST_METHOD'];

// Verifica si la petición es GET
if ($method === 'GET') {
    // Extrae el parámetro 'id_usuario_pertenece_conductor' de la URL si está presente
    if (isset($_GET['id_usuario_pertenece_conductor'])) {
        $id_usuario_pertenece_conductor = $_GET['id_usuario_pertenece_conductor'];

        // Preparar la segunda consulta
        $sql = "SELECT c.*, u.placa_unidad
                FROM conductores c
                LEFT JOIN unidades u ON c.id_conductor = u.id_conductor_unidad
                WHERE c.id_usuario_pertenece_conductor = :id_usuario_pertenece_conductor";

        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':id_usuario_pertenece_conductor', $id_usuario_pertenece_conductor, PDO::PARAM_INT);
        $stmt->execute();
        $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

        echo json_encode($result);
    } else {
        // Ejecutar la primera consulta
        $sql = "SELECT * FROM conductores";
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
