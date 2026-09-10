<?php
declare(strict_types=1);

namespace App\Models;

use PDO;

final class SiteContent
{
    public function __construct(private PDO $database)
    {
    }

    public function all(): array
    {
        $rows = $this->database
            ->query('SELECT content_key, content_value FROM site_content')
            ->fetchAll();

        $content = [];
        foreach ($rows as $row) {
            $content[$row['content_key']] = $row['content_value'];
        }

        return $content;
    }
}
