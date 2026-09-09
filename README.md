# Website Portfolio Yayasan Mefeng Jaya

Template portfolio berbahasa Indonesia menggunakan HTML, CSS, JavaScript vanilla, PHP, dan MySQL. Seluruh konten halaman dimuat dari database melalui API.

## Menjalankan dengan XAMPP

1. Salin folder proyek ini ke `C:\xampp\htdocs\mefeng-jaya`.
2. Jalankan **Apache** dan **MySQL** dari XAMPP Control Panel.
3. Buka `http://localhost/phpmyadmin`, buat/import database dengan memilih file `schema.sql`. Schema membuat database `mefeng_jaya` beserta tabel `profile`, `gallery`, dan `messages`.
4. Jika konfigurasi MySQL lokal berbeda, ubah konstanta di `api/config.php`. Nilai bawaan memakai user `root` tanpa password yang umum pada instalasi XAMPP baru; gunakan kredensial lokal Anda, bukan kredensial nyata.
5. Buka `http://localhost/mefeng-jaya/`. Jangan membuka `index.html` langsung dari `file://` jika ingin menguji API PHP.

## Struktur

- `index.html` — kerangka halaman utama; teks dan data diisi dari database oleh JavaScript.
- `styles.css` — desain responsif, aksesibel, serta animasi ringan pada link media sosial.
- `script.js` — menu mobile, fetch profile/gallery dari database, modal, validasi, dan pengiriman form.
- `api/config.php` — konfigurasi PDO lokal.
- `api/data.php` — endpoint `GET ?route=page`, `GET ?route=profile`, `GET ?route=gallery`, dan `POST ?route=messages`.
- `schema.sql` — schema dan data awal database phpMyAdmin, termasuk tabel `site_content`.

Ubah teks halaman pada tabel `site_content`, data kontak dan tautan media sosial pada tabel `contact_settings`, serta data galeri pada tabel `gallery`.
