<?php
declare(strict_types=1);

require __DIR__ . '/config.php';
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$route = $_GET['route'] ?? 'profile';

try {
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'profile') {
        $profile = db()->query('SELECT * FROM profile ORDER BY id DESC LIMIT 1')->fetch();
        echo json_encode(['profile' => $profile ?: null], JSON_UNESCAPED_UNICODE);
        exit;
    }
    if ($_SERVER['REQUEST_METHOD'] === 'GET' && $route === 'gallery') {
        $gallery = db()->query('SELECT id, title, description, image_url AS image FROM gallery WHERE is_published = 1 ORDER BY sort_order, id DESC')->fetchAll();
        echo json_encode(['gallery' => $gallery], JSON_UNESCAPED_UNICODE);
        exit;
    }
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && $route === 'messages') {
        $input = json_decode(file_get_contents('php://input'), true) ?: $_POST;
        $name = trim((string)($input['name'] ?? ''));
        $email = trim((string)($input['email'] ?? ''));
        $phone = trim((string)($input['phone'] ?? ''));
        $address = trim((string)($input['address'] ?? ''));
        $message = trim((string)($input['message'] ?? ''));

        if (!preg_match('/^[\p{L}\p{M}][\p{L}\p{M}\s.\'-]{1,119}$/u', $name)) {
            http_response_code(422);
            echo json_encode(['message' => 'Nama lengkap minimal 2 karakter.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        if (strlen($email) > 190 || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            http_response_code(422);
            echo json_encode(['message' => 'Format email tidak valid.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        if (!preg_match('/^(?:\+62|62|0)8[0-9\s-]{7,11}$/', $phone) || strlen(preg_replace('/\D/', '', $phone)) < 10) {
            http_response_code(422);
            echo json_encode(['message' => 'Nomor telepon tidak valid.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        if (strlen($address) < 10 || strlen($address) > 255 || preg_match('/[\x00-\x1F\x7F]/', $address)) {
            http_response_code(422);
            echo json_encode(['message' => 'Alamat minimal 10 karakter.'], JSON_UNESCAPED_UNICODE);
            exit;
        }
        if (strlen($message) < 20 || strlen($message) > 1000 || preg_match('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/', $message)) {
            http_response_code(422);
            echo json_encode(['message' => 'Pesan minimal 20 karakter.'], JSON_UNESCAPED_UNICODE);
            exit;
        }

        $statement = db()->prepare('INSERT INTO messages (name, email, phone, address, message) VALUES (:name, :email, :phone, :address, :message)');
        $statement->execute([
            'name' => $name,
            'email' => $email,
            'phone' => $phone,
            'address' => $address,
            'message' => $message,
        ]);

        http_response_code(201);
        echo json_encode(['message' => 'Terima kasih. Pesan Anda telah diterima dan disimpan ke database.'], JSON_UNESCAPED_UNICODE);
        exit;
    }
    http_response_code(404);
    echo json_encode(['message' => 'Rute API tidak ditemukan.'], JSON_UNESCAPED_UNICODE);
} catch (PDOException $error) {
    http_response_code(503);
    echo json_encode(['message' => 'Database belum tersedia. Jalankan schema.sql terlebih dahulu.'], JSON_UNESCAPED_UNICODE);
}
