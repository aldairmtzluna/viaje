<?php
header('Content-Type: application/json');
require 'db.php';

$request = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

// Extraer la parte de la ruta después de 'index.php'
$path = parse_url($request, PHP_URL_PATH);
$segments = explode('/', trim($path, '/'));

if (count($segments) >= 2 && $segments[0] === 'index.php') {
    switch ($segments[1]) {
        case 'mensajes':
            require 'mensajes.php';
            break;

        case 'usuarios':
            require 'usuarios.php';
            break;

        case 'login':
            require 'login.php';
            break;

        case 'conductores':
            require 'conductores.php';
            break;
            
        case 'unidades':
            require 'unidades.php';
            break;
            
        case 'viajes':
            require 'viajes.php';
            break;
            
        case 'inspecciones':
            require 'inspecciones.php';
            break;
            
        case 'detalles_inspeccion':
            require 'detalles_inspeccion.php';
            break;
            
        case 'flotillas':
            require 'flotillas.php';
            break;

        default:
            header("HTTP/1.1 404 Not Found");
            echo json_encode(['message' => 'No encontrado']);
            break;
    }
} else {
    header("HTTP/1.1 404 Not Found");
    echo json_encode(['message' => 'No encontrado']);
}
