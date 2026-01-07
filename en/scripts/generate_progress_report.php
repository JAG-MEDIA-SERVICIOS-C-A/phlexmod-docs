<?php
// /var/www/html/phlexmod/scripts/generate_progress_report.php

$projectRoot = realpath(__DIR__ . '/..');
$pmDir = $projectRoot . '/projectmanager';

$progressFile = $pmDir . '/avances.json';
$reportFile = $pmDir . '/avances.md';

$data = json_decode(file_get_contents($progressFile), true);

$markdown = "# Reporte de Avances - " . $data['fecha'] . "\n\n";
$markdown .= "## Fase Actual: " . $data['fase_actual'] . "\n\n";
$markdown .= "### Progreso Cuantitativo\n";
foreach ($data['progreso_cuantitativo'] as $area => $value) {
    $markdown .= "- $area: $value%\n";
}

$markdown .= "\n### Progreso Cualitativo\n";
foreach ($data['progreso_cualitativo'] as $area => $description) {
    $markdown .= "- $area: $description\n";
}

$markdown .= "\n### Tareas Pendientes\n";
foreach ($data['tareas'] as $task) {
    $markdown .= "- [ ] " . $task['descripcion'] . " (Estado: " . $task['estado'] . ", Fecha estimada: " . $task['fecha_estimada_completacion'] . ")\n";
}

$markdown .= "\n### Timeline\n";
foreach ($data['timeline'] as $phase) {
    $markdown .= "- " . $phase['fase'] . ": " . $phase['fecha_inicio'] . " - " . $phase['fecha_fin_estimada'] . " (Completado: " . $phase['completado'] . "%)\n";
}

file_put_contents($reportFile, $markdown);
