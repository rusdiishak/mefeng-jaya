<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Models\ContactSetting;
use App\Models\Gallery;
use App\Models\Profile;
use App\Models\SiteContent;

final class PageController
{
    public function __construct(
        private Profile $profile,
        private ContactSetting $contact,
        private SiteContent $content,
        private Gallery $gallery
    ) {
    }

    public function page(): array
    {
        return [
            'profile' => $this->profile->latest(),
            'contact' => $this->contact->current(),
            'content' => $this->content->all(),
            'gallery' => $this->gallery->published(),
        ];
    }

    public function profile(): array
    {
        return ['profile' => $this->profile->latest()];
    }

    public function gallery(): array
    {
        return ['gallery' => $this->gallery->published()];
    }
}
