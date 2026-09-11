<?php
declare(strict_types=1);

$path = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH);
$path = is_string($path) ? rawurldecode($path) : '/';

if (preg_match('#(^|/)\.#', $path) || preg_match('/\.(?:env|ini|log|sql|sqlite|bak|backup|old)$/i', $path)) {
    http_response_code(404);
    exit;
}

$file = __DIR__ . DIRECTORY_SEPARATOR . ltrim($path, '/\\');
if ($path !== '/' && is_file($file)) {
    return false;
}

readfile(__DIR__ . DIRECTORY_SEPARATOR . 'index.html');
