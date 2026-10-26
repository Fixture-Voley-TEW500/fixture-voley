<?php
// Conexión a la base de datos con PDO
$servidor  = 'localhost';
$basedatos = 'db_fixture_voley';
$usuario   = 'root';
$clave     = '';

try {
    $pdo = new PDO("mysql:host=$servidor;dbname=$basedatos;charset=utf8mb4", $usuario, $clave, [
        PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    die('Error al conectar con la base de datos');
}

// Devuelve la tabla de posiciones del torneo publicado (o del torneo indicado)
function obtenerTablaPosiciones($pdo, $id_torneo = null)
{
    if ($id_torneo === null) {
        $torneo = $pdo->query("SELECT id_torneo FROM torneos
                               WHERE tabla_publicada = 1
                               ORDER BY fecha_inicio DESC LIMIT 1")->fetch();
        if (!$torneo) {
            return [];
        }
        $id_torneo = $torneo['id_torneo'];
    }

    $sql = "SELECT equipo, pj, pg, pp, sets_favor, sets_contra, dif_sets, puntos
            FROM vista_tabla_posiciones
            WHERE id_torneo = ?
            ORDER BY puntos DESC, dif_sets DESC, sets_favor DESC, equipo ASC";
    $consulta = $pdo->prepare($sql);
    $consulta->execute([$id_torneo]);
    return $consulta->fetchAll();
}
