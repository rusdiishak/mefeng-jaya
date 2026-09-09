# Website Portfolio Yayasan Mefeng Jaya

Template portfolio standalone berbahasa Indonesia menggunakan HTML, CSS, JavaScript vanilla, PHP, dan MySQL. Frontend tetap menampilkan data demo apabila API belum aktif.

## Menjalankan dengan XAMPP

1. Salin folder proyek ini ke `C:\xampp\htdocs\mefeng-jaya`.
2. Jalankan **Apache** dan **MySQL** dari XAMPP Control Panel.
3. Buka `http://localhost/phpmyadmin`, buat/import database dengan memilih file `schema.sql`. Schema membuat database `mefeng_jaya` beserta tabel `profile`, `gallery`, dan `messages`.
4. Jika konfigurasi MySQL lokal berbeda, ubah konstanta di `api/config.php`. Nilai bawaan memakai user `root` tanpa password yang umum pada instalasi XAMPP baru; gunakan kredensial lokal Anda, bukan kredensial nyata.
5. Buka `http://localhost/mefeng-jaya/`. Jangan membuka `index.html` langsung dari `file://` jika ingin menguji API PHP.

## Struktur

- `index.html` — halaman utama dengan Home, About, Gallery, Contact, form Messages, dan footer.
- `styles.css` — desain responsif, aksesibel, serta animasi ringan pada link media sosial.
- `script.js` — menu mobile, fetch profile/gallery dari database, modal, validasi, dan pengiriman form.
- `api/config.php` — konfigurasi PDO lokal.
- `api/data.php` — endpoint `GET ?route=profile`, `GET ?route=gallery`, dan `POST ?route=messages`.
- `schema.sql` — schema dan data awal database phpMyAdmin.

Media sosial pada template menggunakan tautan contoh. Ganti URL Instagram, Facebook, dan YouTube pada `index.html` dengan akun resmi yayasan.
