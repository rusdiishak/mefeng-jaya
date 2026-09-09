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
