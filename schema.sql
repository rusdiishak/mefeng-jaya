CREATE DATABASE IF NOT EXISTS mefeng_jaya CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE mefeng_jaya;

CREATE TABLE IF NOT EXISTS profile (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  tagline VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  address VARCHAR(255),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS gallery (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(150) NOT NULL,
  description VARCHAR(255) NOT NULL,
  image_url VARCHAR(500),
  sort_order INT NOT NULL DEFAULT 0,
  is_published TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS messages (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  address VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  status ENUM('new', 'read', 'replied') NOT NULL DEFAULT 'new',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_messages_status (status)
);

CREATE TABLE IF NOT EXISTS contact_settings (
  id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
  email VARCHAR(255) NOT NULL DEFAULT '',
  phone VARCHAR(80) NOT NULL DEFAULT '',
  address TEXT NOT NULL,
  map_url VARCHAR(1000) NOT NULL DEFAULT '',
  instagram_url VARCHAR(500) NOT NULL DEFAULT '',
  facebook_url VARCHAR(500) NOT NULL DEFAULT '',
  youtube_url VARCHAR(500) NOT NULL DEFAULT '',
  footer_text VARCHAR(255) NOT NULL DEFAULT '',
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS site_content (
  content_key VARCHAR(100) PRIMARY KEY,
  content_value TEXT NOT NULL,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO profile (name, tagline, description, phone, email, address)
SELECT 'Yayasan Mefeng Jaya', 'Pendidikan yang menyalakan harapan.', 'Yayasan yang bergerak di bidang pendidikan dan menaungi SMP Mefeng.', '+62 812 3456 7890', 'halo@yayasanmefengjaya.or.id', 'Indonesia'
WHERE NOT EXISTS (SELECT 1 FROM profile);

INSERT INTO gallery (title, description, image_url, sort_order)
SELECT 'Belajar bersama di SMP Mefeng', 'Ruang kelas yang penuh cerita', '', 1
WHERE NOT EXISTS (SELECT 1 FROM gallery);

INSERT INTO gallery (title, description, image_url, sort_order)
SELECT 'Kegiatan kreatif siswa', 'Berani berkreasi', '', 2
WHERE NOT EXISTS (SELECT 1 FROM gallery WHERE title = 'Kegiatan kreatif siswa');

INSERT INTO gallery (title, description, image_url, sort_order)
SELECT 'Komunitas yang saling mendukung', 'Tumbuh bersama', '', 3
WHERE NOT EXISTS (SELECT 1 FROM gallery WHERE title = 'Komunitas yang saling mendukung');

INSERT INTO contact_settings (
  id, email, phone, address, map_url, instagram_url, facebook_url, youtube_url, footer_text
)
SELECT
  1,
  'halo@yayasanmefengjaya.or.id',
  '+62 812 3456 7890',
  'Indonesia',
  'https://www.google.com/maps',
  'https://instagram.com',
  'https://facebook.com',
  'https://youtube.com',
  '(c) 2026 Yayasan Mefeng Jaya. Semua hak dilindungi.'
WHERE NOT EXISTS (SELECT 1 FROM contact_settings WHERE id = 1);

INSERT INTO site_content (content_key, content_value)
SELECT 'meta_description', 'Profil Yayasan Mefeng Jaya, yayasan yang bergerak di bidang pendidikan dan menaungi SMP Mefeng.'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'meta_description');
INSERT INTO site_content (content_key, content_value)
SELECT 'page_title', 'Yayasan Mefeng Jaya | Pendidikan untuk Masa Depan'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'page_title');
INSERT INTO site_content (content_key, content_value)
SELECT 'skip_link', 'Lewati ke konten utama'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'skip_link');
INSERT INTO site_content (content_key, content_value)
SELECT 'brand_name', 'Yayasan Mefeng Jaya'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'brand_name');
INSERT INTO site_content (content_key, content_value)
SELECT 'nav_home', 'Home'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'nav_home');
INSERT INTO site_content (content_key, content_value)
SELECT 'nav_about', 'About'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'nav_about');
INSERT INTO site_content (content_key, content_value)
SELECT 'nav_gallery', 'Gallery'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'nav_gallery');
INSERT INTO site_content (content_key, content_value)
SELECT 'nav_contact', 'Contact'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'nav_contact');
INSERT INTO site_content (content_key, content_value)
SELECT 'nav_message', 'Kirim Pesan'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'nav_message');
INSERT INTO site_content (content_key, content_value)
SELECT 'menu_open', 'Buka menu'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'menu_open');
INSERT INTO site_content (content_key, content_value)
SELECT 'hero_eyebrow', 'Membangun generasi berkarakter'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'hero_eyebrow');
INSERT INTO site_content (content_key, content_value)
SELECT 'hero_title', 'Pendidikan yang menyalakan <em>harapan.</em>'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'hero_title');
INSERT INTO site_content (content_key, content_value)
SELECT 'hero_description', 'Yayasan Mefeng Jaya hadir untuk membuka akses pendidikan yang bermakna, inklusif, dan berkelanjutan bagi anak-anak Indonesia.'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'hero_description');
INSERT INTO site_content (content_key, content_value)
SELECT 'hero_about_button', 'Kenali yayasan'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'hero_about_button');
INSERT INTO site_content (content_key, content_value)
SELECT 'hero_contact_button', 'Hubungi kami'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'hero_contact_button');
INSERT INTO site_content (content_key, content_value)
SELECT 'hero_proof', 'Pendidikan|untuk setiap langkah'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'hero_proof');
INSERT INTO site_content (content_key, content_value)
SELECT 'art_card_top', 'Belajar'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'art_card_top');
INSERT INTO site_content (content_key, content_value)
SELECT 'art_card_top_small', 'hari ini'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'art_card_top_small');
INSERT INTO site_content (content_key, content_value)
SELECT 'art_card_bottom', 'Berani'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'art_card_bottom');
INSERT INTO site_content (content_key, content_value)
SELECT 'art_card_bottom_small', 'bermimpi'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'art_card_bottom_small');
INSERT INTO site_content (content_key, content_value)
SELECT 'about_eyebrow', 'Tentang kami'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'about_eyebrow');
INSERT INTO site_content (content_key, content_value)
SELECT 'about_title', 'Menumbuhkan potensi,<br><em>menguatkan masa depan.</em>'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'about_title');
INSERT INTO site_content (content_key, content_value)
SELECT 'about_paragraph_1', 'Yayasan Mefeng Jaya bergerak di bidang pendidikan dengan semangat mendampingi generasi muda agar tumbuh menjadi pribadi yang cerdas, berkarakter, dan peduli terhadap sesama.'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'about_paragraph_1');
INSERT INTO site_content (content_key, content_value)
SELECT 'about_paragraph_2', 'Melalui <strong>SMP Mefeng</strong>, kami menghadirkan lingkungan belajar yang aman, kreatif, dan mendorong setiap siswa untuk menemukan potensi terbaiknya.'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'about_paragraph_2');
INSERT INTO site_content (content_key, content_value)
SELECT 'about_link', 'Pelajari lebih lanjut'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'about_link');
INSERT INTO site_content (content_key, content_value)
SELECT 'stats_label', 'Ringkasan yayasan'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'stats_label');
INSERT INTO site_content (content_key, content_value)
SELECT 'stat_1', '01|Fokus pada pendidikan berkualitas'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'stat_1');
INSERT INTO site_content (content_key, content_value)
SELECT 'stat_2', '∞|Ruang untuk setiap mimpi'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'stat_2');
INSERT INTO site_content (content_key, content_value)
SELECT 'stat_3', '1|Komunitas belajar: SMP Mefeng'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'stat_3');
INSERT INTO site_content (content_key, content_value)
SELECT 'gallery_eyebrow', 'Cerita kami'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'gallery_eyebrow');
INSERT INTO site_content (content_key, content_value)
SELECT 'gallery_title', 'Momen yang <em>berarti.</em>'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'gallery_title');
INSERT INTO site_content (content_key, content_value)
SELECT 'gallery_intro', 'Setiap kegiatan adalah kesempatan untuk belajar, berbagi, dan bertumbuh bersama.'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'gallery_intro');
INSERT INTO site_content (content_key, content_value)
SELECT 'contact_eyebrow', 'Mari terhubung'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'contact_eyebrow');
INSERT INTO site_content (content_key, content_value)
SELECT 'contact_title', 'Setiap dukungan<br><em>berarti.</em>'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'contact_title');
INSERT INTO site_content (content_key, content_value)
SELECT 'contact_intro', 'Ingin mengetahui lebih banyak tentang program kami atau berkolaborasi? Kami senang mendengar dari Anda.'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'contact_intro');
INSERT INTO site_content (content_key, content_value)
SELECT 'map_label', 'Lokasi'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'map_label');
INSERT INTO site_content (content_key, content_value)
SELECT 'map_name', 'SMP Mefeng'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'map_name');
INSERT INTO site_content (content_key, content_value)
SELECT 'message_form_label', 'Messages / Form kontak'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'message_form_label');
INSERT INTO site_content (content_key, content_value)
SELECT 'message_form_title', 'Kirim pesan kepada kami'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'message_form_title');
INSERT INTO site_content (content_key, content_value)
SELECT 'field_name', 'Nama lengkap'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'field_name');
INSERT INTO site_content (content_key, content_value)
SELECT 'field_email', 'Alamat email'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'field_email');
INSERT INTO site_content (content_key, content_value)
SELECT 'field_phone', 'Nomor telepon'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'field_phone');
INSERT INTO site_content (content_key, content_value)
SELECT 'field_address', 'Alamat'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'field_address');
INSERT INTO site_content (content_key, content_value)
SELECT 'field_message', 'Pesan'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'field_message');
INSERT INTO site_content (content_key, content_value)
SELECT 'form_submit', 'Kirim pesan'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'form_submit');
INSERT INTO site_content (content_key, content_value)
SELECT 'footer_back', 'Kembali ke atas'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'footer_back');
INSERT INTO site_content (content_key, content_value)
SELECT 'social_instagram_label', 'Instagram'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'social_instagram_label');
INSERT INTO site_content (content_key, content_value)
SELECT 'social_facebook_label', 'Facebook'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'social_facebook_label');
INSERT INTO site_content (content_key, content_value)
SELECT 'social_youtube_label', 'YouTube'
WHERE NOT EXISTS (SELECT 1 FROM site_content WHERE content_key = 'social_youtube_label');
