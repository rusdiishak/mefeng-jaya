<?php
declare(strict_types=1);

namespace App\Models;

use PDO;

final class ContactSetting
{
    public function __construct(private PDO $database)
    {
    }

    public function current(): ?array
    {
        $statement = $this->database->prepare(
            'SELECT * FROM contact_settings WHERE id = :id'
        );
        $statement->execute(['id' => 1]);
        $contact = $statement->fetch();

        return $contact ?: null;
    }
}
