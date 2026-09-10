# Website Portfolio Yayasan Mefeng Jaya

Template portfolio berbahasa Indonesia menggunakan HTML, CSS, JavaScript vanilla, PHP, dan MySQL. Seluruh konten halaman dimuat dari database melalui API.

## Menjalankan dengan XAMPP

1. Salin folder proyek ini ke `C:\xampp\htdocs\mefeng-jaya`.
2. Jalankan **Apache** dan **MySQL** dari XAMPP Control Panel.
3. Buka `http://localhost/phpmyadmin`, buat/import database dengan memilih file `schema.sql`. Schema membuat database `mefeng_jaya` beserta tabel `profile`, `gallery`, dan `messages`.
4. Jika konfigurasi MySQL lokal berbeda, ubah konstanta di `api/config.php`. Nilai bawaan memakai user `root` tanpa password yang umum pada instalasi XAMPP baru; gunakan kredensial lokal Anda, bukan kredensial nyata.
5. Buka `http://localhost/mefeng-jaya/`. Jangan membuka `index.html` langsung dari `file://` jika ingin menguji API PHP.

## Struktur MVC

Project ini menggunakan MVC ringan tanpa framework PHP. Berikut struktur utamanya:

```text
mefeng-jaya/
├── index.html                  # VIEW: template halaman utama
├── styles.css                  # VIEW: styling dan responsive layout
├── script.js                   # VIEW: interaksi browser dan pemanggilan API
├── api/
│   ├── data.php                # CONTROLLER/route entry point untuk API
│   └── config.php              # konfigurasi koneksi database API
├── app/
│   ├── Controllers/             # CONTROLLER: alur request dan response
│   │   ├── PageController.php
│   │   └── MessageController.php
│   ├── Models/                 # MODEL: query dan akses data database
│   │   ├── Profile.php
│   │   ├── Gallery.php
│   │   ├── ContactSetting.php
│   │   ├── SiteContent.php
│   │   └── Message.php
│   └── Core/                    # komponen inti bersama
│       └── ValidationException.php
├── assets/
│   └── bootstrap/               # Bootstrap 5.3.8 lokal
├── schema.sql                   # struktur dan data awal database
└── data.php                     # endpoint lama; tidak dipakai frontend aktif
```

### View

View adalah tampilan yang dilihat pengguna. Pada project ini view tidak memakai
template PHP, melainkan HTML/CSS/JavaScript:

- `index.html` — struktur halaman Home, About, Gallery, Contact, dan form pesan.
- `styles.css` — tampilan, breakpoint mobile/tablet/laptop/desktop, dan layout Gallery.
- `script.js` — menu mobile, pengambilan data API, render Gallery, modal, validasi,
  dan pengiriman form.

### Controller

Controller menerima request, memanggil model, lalu mengembalikan response:

- `api/data.php` — entry point API aktif yang membaca `route` dan meneruskan
  request ke controller.
- `app/Controllers/PageController.php` — menggabungkan data profile, kontak,
  konten halaman, dan gallery.
- `app/Controllers/MessageController.php` — memvalidasi dan menyimpan pesan
  kontak baru.

### Model

Model berisi query database dan tidak mengatur tampilan:

- `app/Models/Profile.php` — data profile yayasan.
- `app/Models/Gallery.php` — daftar gambar gallery yang dipublikasikan.
- `app/Models/ContactSetting.php` — email, telepon, alamat, media sosial, dan peta.
- `app/Models/SiteContent.php` — teks halaman yang dapat diubah dari database.
- `app/Models/Message.php` — penyimpanan pesan dari form kontak.

### Alur request

```text
Browser (index.html + script.js)
        ↓
api/data.php
        ↓
Controller
        ↓
Model
        ↓
MySQL
```

`data.php` di root adalah endpoint versi lama yang dipertahankan untuk
kompatibilitas. Frontend aktif menggunakan `api/data.php`, sehingga kode baru
sebaiknya ditambahkan ke `app/Controllers/` dan `app/Models/`, bukan ke
`data.php` root.

Ubah teks halaman pada tabel `site_content`, data kontak dan tautan media sosial pada tabel `contact_settings`, serta data galeri pada tabel `gallery`.
