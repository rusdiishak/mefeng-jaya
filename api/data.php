<?php
declare(strict_types=1);

use App\Controllers\MessageController;
use App\Controllers\PageController;
use App\Core\ValidationException;
use App\Models\ContactSetting;
use App\Models\Gallery;
use App\Models\Message;
use App\Models\Profile;
use App\Models\SiteContent;

require __DIR__ . '/config.php';

spl_autoload_register(static function (string $class): void {
    $prefix = 'App\\';
    if (strncmp($class, $prefix, strlen($prefix)) !== 0) {
        return;
    }

    $relativeClass = substr($class, strlen($prefix));
    $file = dirname(__DIR__) . '/app/' . str_replace('\\', '/', $relativeClass) . '.php';
    if (is_file($file)) {
        require $file;
    }
});

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function respond(array $payload, int $status = 200): void
{
    http_response_code($status);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE);
    exit;
}

function requestInput(): array
{
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        return [];
    }

    $body = file_get_contents('php://input');
    if ($body === false || $body === '') {
        return $_POST;
    }

    $input = json_decode($body, true);
    if (!is_array($input)) {
        respond(['message' => 'Format data permintaan tidak valid.'], 400);
    }

    return $input;
}

try {
    $database = db();
    $pageController = new PageController(
        new Profile($database),
        new ContactSetting($database),
        new SiteContent($database),
        new Gallery($database)
    );
    $route = $_GET['route'] ?? 'profile';

    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'page') {
        respond($pageController->page());
    }
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'profile') {
        respond($pageController->profile());
    }
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'gallery') {
        respond($pageController->gallery());
    }
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && $route === 'messages') {
        (new MessageController(new Message($database)))->store(requestInput());
        respond(['message' => 'Terima kasih. Pesan Anda telah diterima dan disimpan ke database.'], 201);
    }

    respond(['message' => 'Rute API tidak ditemukan.'], 404);
} catch (ValidationException $error) {
    respond(['message' => $error->getMessage()], 422);
} catch (PDOException $error) {
    respond(['message' => 'Database belum tersedia. Jalankan schema.sql terlebih dahulu.'], 503);
}
