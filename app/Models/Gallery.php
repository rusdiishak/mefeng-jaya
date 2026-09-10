<?php
declare(strict_types=1);

namespace App\Models;

use PDO;

final class Gallery
{
    public function __construct(private PDO $database)
    {
    }

    public function published(): array
    {
        $statement = $this->database->query(
            'SELECT id, title, description, image_url AS image
             FROM gallery
             WHERE is_published = 1
             ORDER BY sort_order, id DESC'
        );

        return $statement->fetchAll();
    }
}
