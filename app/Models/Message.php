<?php
declare(strict_types=1);

namespace App\Models;

use PDO;

final class Message
{
    public function __construct(private PDO $database)
    {
    }

    public function create(array $message): void
    {
        $statement = $this->database->prepare(
            'INSERT INTO messages (name, email, phone, address, message)
             VALUES (:name, :email, :phone, :address, :message)'
        );
        $statement->execute($message);
    }
}
