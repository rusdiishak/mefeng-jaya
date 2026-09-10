<?php
declare(strict_types=1);

namespace App\Models;

use PDO;

final class Profile
{
    public function __construct(private PDO $database)
    {
    }

    public function latest(): ?array
    {
        $statement = $this->database->query(
            'SELECT * FROM profile ORDER BY id DESC LIMIT 1'
        );
        $profile = $statement->fetch();

        return $profile ?: null;
    }
}
