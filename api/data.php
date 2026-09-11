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

ini_set('session.use_strict_mode', '1');
$isHttps = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off';
if (getenv('MEFENG_FORCE_HTTPS') === '1' && !$isHttps) {
    $host = $_SERVER['HTTP_HOST'] ?? '';
    $uri = $_SERVER['REQUEST_URI'] ?? '/';
    header('Location: https://' . $host . $uri, true, 308);
    exit;
}
session_set_cookie_params([
    'httponly' => true,
    'samesite' => 'Lax',
    'secure' => $isHttps || getenv('MEFENG_FORCE_HTTPS') === '1',
]);
session_start();

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
header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: strict-origin-when-cross-origin');
if ($isHttps) {
    header('Strict-Transport-Security: max-age=31536000; includeSubDomains');
}

function csrfToken(): string
{
    if (empty($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }

    return $_SESSION['csrf_token'];
}

function validateRequestOrigin(): void
{
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if ($origin === '') {
        return;
    }

    $expected = (($_SERVER['HTTPS'] ?? 'off') !== 'off' ? 'https' : 'http')
        . '://' . ($_SERVER['HTTP_HOST'] ?? '');
    if (!hash_equals($expected, $origin)) {
        respond(['message' => 'Sumber permintaan tidak diizinkan.'], 403);
    }
}

function validateCsrfToken(): void
{
    $submitted = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
    if (!is_string($submitted) || !hash_equals((string)($_SESSION['csrf_token'] ?? ''), $submitted)) {
        respond(['message' => 'Token keamanan tidak valid. Muat ulang halaman lalu coba lagi.'], 403);
    }
}

function validateMessageRate(): void
{
    $lastMessageAt = (int)($_SESSION['last_message_at'] ?? 0);
    if ($lastMessageAt > 0 && time() - $lastMessageAt < 15) {
        respond(['message' => 'Tunggu beberapa detik sebelum mengirim pesan lagi.'], 429);
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(405);
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
        $page = $pageController->page();
        $page['csrf_token'] = csrfToken();
        respond($page);
    }
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'profile') {
        respond($pageController->profile());
    }
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'gallery') {
        respond($pageController->gallery());
    }
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && $route === 'messages') {
        validateRequestOrigin();
        validateCsrfToken();
        validateMessageRate();
        $input = requestInput();
        if (!empty($input['website'])) {
            respond(['message' => 'Permintaan tidak valid.'], 422);
        }
        (new MessageController(new Message($database)))->store($input);
        $_SESSION['last_message_at'] = time();
        respond(['message' => 'Terima kasih. Pesan Anda telah diterima dan disimpan ke database.'], 201);
    }

    respond(['message' => 'Rute API tidak ditemukan.'], 404);
} catch (ValidationException $error) {
    respond(['message' => $error->getMessage()], 422);
} catch (RuntimeException $error) {
    respond(['message' => 'Konfigurasi server belum lengkap.'], 503);
} catch (PDOException $error) {
    respond(['message' => 'Database belum tersedia. Jalankan schema.sql terlebih dahulu.'], 503);
}
