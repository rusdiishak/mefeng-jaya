# Website Portfolio Yayasan Mefeng Jaya

Template portfolio berbahasa Indonesia menggunakan HTML, CSS, JavaScript vanilla, PHP, dan MySQL. Seluruh konten halaman dimuat dari database melalui API.

## Menjalankan dengan XAMPP

1. Salin folder proyek ini ke `C:\xampp\htdocs\mefeng-jaya`.
2. Jalankan **Apache** dan **MySQL** dari XAMPP Control Panel.
3. Buka `http://localhost/phpmyadmin`, buat/import database dengan memilih file `schema.sql`. Schema membuat database `mefeng_jaya` beserta tabel `profile`, `gallery`, dan `messages`.
4. Atur variabel `MEFENG_DB_HOST`, `MEFENG_DB_NAME`, `MEFENG_DB_USER`, dan `MEFENG_DB_PASS` melalui environment Apache/PHP atau panel hosting. Gunakan user database khusus aplikasi, bukan `root`. Lihat `.env.example` sebagai referensi nama variabel.
5. Buka `http://localhost/mefeng-jaya/`. Jangan membuka `index.html` langsung dari `file://` jika ingin menguji API PHP.

Jangan mengunggah file backup SQL ke document root. Simpan backup di luar folder website atau gunakan penyimpanan backup dari hosting.

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
├── .env.example                 # contoh nama variabel environment
└── .htaccess                    # hardening Apache dasar
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

Frontend aktif menggunakan `api/data.php`. Endpoint lama di root telah
dihapus agar tidak ada jalur API duplikat dengan konfigurasi keamanan berbeda.
Kode baru sebaiknya ditambahkan ke `app/Controllers/` dan `app/Models/`.

Endpoint pesan menggunakan token CSRF berbasis session, validasi origin, dan
honeypot anti-spam. Untuk production, gunakan HTTPS dan aktifkan kredensial
database melalui panel hosting, bukan melalui file yang di-commit.

Ubah teks halaman pada tabel `site_content`, data kontak dan tautan media sosial pada tabel `contact_settings`, serta data galeri pada tabel `gallery`.
