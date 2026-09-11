<?php
declare(strict_types=1);

function loadLocalEnvironment(): void
{
    $configuredFile = getenv('MEFENG_ENV_FILE');
    $file = $configuredFile !== false && $configuredFile !== ''
        ? $configuredFile
        : dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . '.env';
    if (!is_file($file)) {
        return;
    }

    foreach (file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        $line = trim($line);
        if ($line === '' || str_starts_with($line, '#') || !str_contains($line, '=')) {
            continue;
        }

        [$key, $value] = explode('=', $line, 2);
        $key = trim($key);
        $value = trim($value);
        if ($key !== '' && getenv($key) === false) {
            putenv($key . '=' . trim($value, "\"'"));
        }
    }
}

function db(): PDO
{
    static $pdo;
    if (!$pdo) {
        loadLocalEnvironment();
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
