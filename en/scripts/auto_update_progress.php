<?php
// /var/www/html/phlexmod/scripts/auto_update_progress.php

$projectRoot = realpath(__DIR__ . '/..');
$pmDir = $projectRoot . '/projectmanager';
$progressFile = $pmDir . '/avances.json';

// Read current progress
$data = json_decode(file_get_contents($progressFile), true);

// Update the date
$data['fecha'] = date('Y-m-d');

// Write back
file_put_contents($progressFile, json_encode($data, JSON_PRETTY_PRINT));

// Generate the report
require_once __DIR__ . '/generate_progress_report.php';

// Log
file_put_contents($pmDir . '/update_log.txt', date('Y-m-d H:i:s') . " - Updated\n", FILE_APPEND);
