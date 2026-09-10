<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\ValidationException;
use App\Models\Message;

final class MessageController
{
    public function __construct(private Message $messages)
    {
    }

    public function store(array $input): void
    {
        $message = [
            'name' => trim((string)($input['name'] ?? '')),
            'email' => trim((string)($input['email'] ?? '')),
            'phone' => trim((string)($input['phone'] ?? '')),
            'address' => trim((string)($input['address'] ?? '')),
            'message' => trim((string)($input['message'] ?? '')),
        ];

        $this->validate($message);
        $this->messages->create($message);
    }

    private function validate(array $message): void
    {
        if (!preg_match('/^[\p{L}\p{M}][\p{L}\p{M}\s.\'-]{1,119}$/u', $message['name'])) {
            throw new ValidationException('Nama lengkap minimal 2 karakter.');
        }
        if (strlen($message['email']) > 190 || !filter_var($message['email'], FILTER_VALIDATE_EMAIL)) {
            throw new ValidationException('Format email tidak valid.');
        }
        if (
            !preg_match('/^(?:\+62|62|0)8[0-9\s-]{7,11}$/', $message['phone'])
            || strlen(preg_replace('/\D/', '', $message['phone'])) < 10
        ) {
            throw new ValidationException('Nomor telepon tidak valid.');
        }
        if (
            strlen($message['address']) < 10
            || strlen($message['address']) > 255
            || preg_match('/[\x00-\x1F\x7F]/', $message['address'])
        ) {
            throw new ValidationException('Alamat minimal 10 karakter.');
        }
        if (
            strlen($message['message']) < 20
            || strlen($message['message']) > 1000
            || preg_match('/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/', $message['message'])
        ) {
            throw new ValidationException('Pesan minimal 20 karakter.');
        }
    }
}
