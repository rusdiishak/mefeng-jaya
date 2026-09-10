<?php
declare(strict_types=1);

function db(): PDO
{
    static $pdo;
    if (!$pdo) {
        $host = getenv('MEFENG_DB_HOST');
        $name = getenv('MEFENG_DB_NAME');
        $user = getenv('MEFENG_DB_USER');
        $pass = getenv('MEFENG_DB_PASS');

        if ($host === false || $name === false || $user === false) {
            throw new RuntimeException('Konfigurasi database belum lengkap.');
        }
        if ($pass === false) {
            $pass = '';
        }

        $pdo = new PDO(
            'mysql:host=' . $host . ';dbname=' . $name . ';charset=utf8mb4',
            $user,
            $pass,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
        );
    }
    return $pdo;
}
