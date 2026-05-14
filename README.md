# ASFOUR 2026 - Aplikasi Survei Aspirasi Sekolah

**ASFOUR (Aspirasi Four)** adalah aplikasi berbasis web untuk mengumpulkan, mengelola, dan menganalisis aspirasi dari siswa, guru, dan warga sekolah. Dibangun menggunakan PHP native dengan MySQL dan dilengkapi fitur analisis AI berbasis OpenRouter API.

---

## Daftar Isi

- [Fitur](#fitur)
- [Persyaratan Sistem](#persyaratan-sistem)
- [Instalasi](#instalasi)
- [Struktur Database](#struktur-database)
- [Struktur File](#struktur-file)
- [Role & Hak Akses](#role--hak-akses)
- [Cara Penggunaan](#cara-penggunaan)
- [API & Endpoint](#api--endpoint)
- [Fitur AI Analysis](#fitur-ai-analysis)
- [Keamanan](#keamanan)
- [Teknologi](#teknologi)
- [Pemeliharaan](#pemeliharaan)
- [Troubleshooting](#troubleshooting)

---

## Fitur

### Publik (Pengguna Umum)
- **Landing Page** - Halaman sambutan dengan logo, judul, dan tombol mulai
- **Form Survei Multi-Step** - Proses 4 tahap (Landing → Loading → Form → Terima Kasih)
- **Pemilihan Role** - Guru, Warga Sekolah, Siswa, atau Umum
- **Angkatan Khusus Siswa** - Dropdown angkatan (A'24, A'25, A'26) hanya muncul saat role = Siswa
- **Upload File** - Lampirkan gambar (JPG/PNG/GIF), PDF, atau dokumen (DOC/DOCX)
- **Pratinjau File** - Lihat file yang akan diupload sebelum submit
- **Background Music** - Dua track musik latar (backsound1.mp3 lokal + CDN Pixabay)
- **Responsive Design** - Tampilan mobile-friendly

### Admin Dashboard
- **Overview** - Statistik jumlah responden berdasarkan role (Total, Siswa, Guru, Warga Sekolah)
- **Survey Responses** - Tabel data seluruh aspirasi dengan filter dan pencarian
- **Media Gallery** - Galeri file upload dengan modal pratinjau (gambar inline, PDF embed, file lain sebagai link download)
- **AI Analysis** - Analisis AI otomatis dengan grafik distribusi kategori dan tabel hasil
- **Settings** - Toggle buka/tutup survei (hanya admin & super_admin)
- **Admin Management** - Tambah/hapus akun admin (hanya super_admin)
- **Activity Logs** - Log aktivitas admin (hanya super_admin)
- **CSV Export** - Ekspor seluruh data survei ke file CSV
- **Sidebar Navigation** - Navigasi tab dengan hamburger menu untuk mobile

### AI Analysis
- **Klasifikasi Kategori Otomatis** - Menggunakan Qwen3 Coder 480B via OpenRouter API
- **5 Kategori** - Kesiswaan, Kurikulum, Humas, Sarana Prasarana, Lainnya
- **Sentiment Analysis** - Positive, Negative, Neutral
- **Confidence Score** - Skor kepercayaan 0.00 - 1.00
- **Keyword Fallback** - Analisis berbasis keyword jika API tidak tersedia
- **Chart.js Visualization** - Grafik batang distribusi kategori
- **Rate Limiting** - Delay 0.5 detik antar request API

---

## Persyaratan Sistem

- **Web Server**: Apache 2.4+ (XAMPP / LAMP / MAMP)
- **PHP**: 7.4 atau lebih baru (direkomendasikan 8.0+)
- **MySQL**: 5.7+ atau MariaDB 10.3+
- **Ekstensi PHP**: `pdo_mysql`, `session`, `json`, `fileinfo`
- **Browser**: Chrome, Firefox, Edge, Safari (versi terbaru)
- **Koneksi Internet**: Diperlukan untuk CDN (FontAwesome, Google Fonts, Chart.js) dan OpenRouter API

---

## Instalasi

### 1. Clone / Download Project

Letakkan seluruh file di folder web server, misalnya:
```
C:\xampp\htdocs\ASFOUR 2026\
```

### 2. Database Setup

**Opsi A - Instalasi Baru (Fresh Install):**
1. Buka phpMyAdmin atau MySQL CLI
2. Jalankan file `db.sql`:
```sql
SOURCE C:/xampp/htdocs/ASFOUR 2026/db.sql;
```
Atau copy paste isi `db.sql` ke query window phpMyAdmin.

3. Jika sudah ada database tapi belum ada kolom AI, jalankan:
```sql
SOURCE C:/xampp/htdocs/ASFOUR 2026/migration_ai_analysis.sql;
```

**Opsi B - Update dari DB Lama:**
Jika database `asfour_survey` sudah ada, jalankan `migration_ai_analysis.sql` untuk menambahkan kolom AI:
```sql
SOURCE C:/xampp/htdocs/ASFOUR 2026/migration_ai_analysis.sql;
```

### 3. Konfigurasi Database

File `config.php` sudah dikonfigurasi untuk XAMPP default:
```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'asfour_survey');
define('DB_USER', 'root');
define('DB_PASS', '');
```

Sesuaikan jika menggunakan konfigurasi berbeda.

### 4. Konfigurasi OpenRouter API

Buka `ai_analysis.php` dan ganti `OPENROUTER_API_KEY` dengan API key Anda:
```php
define('OPENROUTER_API_KEY', 'sk-or-v1-xxxxxxxxxxxx');
```

Daftar di https://openrouter.ai/ untuk mendapatkan API key gratis.

### 5. Folder Upload

Pastikan folder `uploads/` memiliki permission write:
```bash
chmod 755 uploads/
# atau di Windows pastikan folder tidak read-only
```

### 6. Akses Aplikasi

- **Halaman Publik**: http://localhost/ASFOUR%202026/
- **Admin Dashboard**: http://localhost/ASFOUR%202026/admin.php

### 7. Login Default

| Username | Password | Role |
|----------|----------|------|
| `admin` | `admin123` | Super Admin |

**Penting:** Segera ganti password setelah login pertama!

---

## Struktur Database

### Table: `surveys`
Menyimpan data aspirasi dari responden.

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT | Primary Key |
| `role` | VARCHAR(50) | Role responden: `Guru`, `Siswa`, `Warga Sekolah`, `Umum` |
| `angkatan` | VARCHAR(20) | Angkatan (hanya untuk Siswa): `A'24`, `A'25`, `A'26` |
| `aspirasi` | TEXT | Isi aspirasi/feedback |
| `file_path` | VARCHAR(255) | Path file lampiran (nullable) |
| `created_at` | TIMESTAMP | Waktu submit |
| `sentiment` | ENUM | Hasil analisis sentimen: `positive`, `negative`, `neutral` |
| `category` | ENUM | Kategori AI: `kesiswaan`, `kurikulum`, `humas`, `sarana_prasarana`, `lainnya` |
| `ai_confidence` | DECIMAL(3,2) | Skor kepercayaan AI (0.00-1.00) |
| `ai_explanation` | TEXT | Penjelasan hasil analisis |
| `analyzed` | TINYINT(1) | Status sudah dianalisis (0/1) |
| `analyzed_at` | TIMESTAMP | Waktu analisis |

### Table: `admins`
Menyimpan data akun admin.

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT | Primary Key |
| `username` | VARCHAR(50) UNIQUE | Username login |
| `password` | VARCHAR(255) | Password (bcrypt hash) |
| `role` | ENUM | `super_admin`, `admin`, `staff` |
| `created_at` | TIMESTAMP | Waktu pembuatan akun |

### Table: `settings`
Menyimpan pengaturan global aplikasi.

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT | Primary Key (selalu 1, di-CHECK) |
| `survey_status` | ENUM | `open` / `closed` |

### Table: `admin_logs`
Menyimpan log aktivitas admin.

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INT AUTO_INCREMENT | Primary Key |
| `admin_id` | INT | Foreign Key ke `admins.id` (ON DELETE SET NULL) |
| `action` | VARCHAR(255) | Deskripsi aksi |
| `details` | TEXT | Detail tambahan |
| `created_at` | TIMESTAMP | Waktu aksi |

### Relasi
- `admin_logs.admin_id` → `admins.id` (ON DELETE SET NULL)

---

## Struktur File

```
ASFOUR 2026/
│
├── .qodo/                      # Konfigurasi IDE agent
├── scratch/                    # Folder temporary
├── uploads/                    # File upload dari responden
│
├── admin.php                   # Admin dashboard (1362 baris)
├── ai_analysis.php             # Handler analisis AI (283 baris)
├── backsound1.mp3              # Musik latar lokal
├── banner.png                  # Banner halaman survei
├── belum_mulai.php             # Halaman survei ditutup
├── config.php                  # Konfigurasi database & helper
├── db.sql                      # Schema & seed database
├── index.php                   # Aplikasi survei publik (SPA)
├── logo.png                    # Logo aplikasi
├── migration_ai_analysis.sql   # Migrasi kolom AI
├── submit_survey.php           # AJAX handler submit survei
└── README.md                   # Dokumentasi ini
```

### Deskripsi File

| File | Fungsi |
|------|--------|
| `index.php` | Aplikasi survei SPA (Single Page Application) 4 halaman: Landing, Loading, Form, Thank You |
| `admin.php` | Dashboard admin all-in-one dengan 7 tab: Overview, Survey Responses, Media Gallery, AI Analysis, Settings, Admin Management, Activity Logs |
| `config.php` | Koneksi database PDO, fungsi `logActivity()`, dan `isSurveyOpen()` |
| `db.sql` | Script pembuatan database, tabel, dan data awal (super admin default) |
| `submit_survey.php` | Endpoint AJAX untuk memproses submit form survei |
| `ai_analysis.php` | Handler analisis AI via OpenRouter API dengan keyword fallback |
| `belum_mulai.php` | Halaman yang ditampilkan saat survei ditutup |
| `migration_ai_analysis.sql` | Script migrasi untuk menambah kolom analisis AI ke tabel `surveys` yang sudah ada |

---

## Role & Hak Akses

| Fitur | super_admin | admin | staff |
|-------|:-----------:|:-----:|:-----:|
| Lihat Overview | ✅ | ✅ | ✅ |
| Lihat Survey Responses | ✅ | ✅ | ✅ |
| Lihat Media Gallery | ✅ | ✅ | ✅ |
| Lihat AI Analysis | ✅ | ✅ | ✅ |
| Export CSV | ✅ | ✅ | ✅ |
| Toggle Buka/Tutup Survei | ✅ | ✅ | ❌ |
| Hapus Survei | ✅ | ❌ | ❌ |
| Tambah/Hapus Admin | ✅ | ❌ | ❌ |
| Lihat Activity Logs | ✅ | ❌ | ❌ |

---

## Cara Penggunaan

### Publik (Mengisi Survei)

1. Buka `index.php`
2. Klik tombol **"MULAI"** di halaman landing
3. Tunggu loading bar (simulasi)
4. Isi form:
   - Pilih **Role** (Guru/Warga Sekolah/Siswa/Umum)
   - Jika memilih **Siswa**, pilih **Angkatan** (A'24/A'25/A'26)
   - Tulis **Aspirasi** di textarea
   - (Opsional) Upload **file pendukung**
5. Klik **"KIRIM"**
6. Lihat halaman **"TERIMA KASIH"**

### Admin (Dashboard)

1. Buka `admin.php`
2. Login dengan username dan password
3. Navigasi menggunakan sidebar:
   - **Overview** - Lihat statistik jumlah responden
   - **Survey Responses** - Lihat, cari, dan export data survei
   - **Media Gallery** - Lihat dan pratinjau file upload
   - **AI Analysis** - Jalankan analisis AI dan lihat grafik
   - **Settings** - Buka/tutup survei
   - **Admin Management** - Kelola akun admin (super_admin only)
   - **Activity Logs** - Lihat riwayat aktivitas (super_admin only)

### Export Data

1. Di tab **Survey Responses**, klik tombol **"Export CSV"**
2. File CSV akan otomatis terdownload

### AI Analysis

1. Di tab **AI Analysis**, klik tombol **"Jalankan Analisis"**
2. Tunggu proses analisis (tergantung jumlah data)
3. Lihat hasil berupa grafik batang distribusi kategori
4. Tabel detail hasil analisis akan muncul di bawah grafik

---

## API & Endpoint

### Endpoint Publik

#### `submit_survey.php`
- **Method**: POST
- **Deskripsi**: Submit data survei baru
- **Content-Type**: `multipart/form-data`
- **Parameter**:
  | Parameter | Tipe | Required | Deskripsi |
  |-----------|------|----------|-----------|
  | `role` | string | ✅ | Guru/Siswa/Warga Sekolah/Umum |
  | `angkatan` | string | ❌ | A'24/A'25/A'26 (hanya jika role=Siswa) |
  | `aspirasi` | string | ✅ | Isi aspirasi |
  | `file` | file | ❌ | File lampiran (max 2MB, jenis: jpg/png/gif/pdf/doc/docx) |
- **Response Sukses**:
  ```json
  { "status": "success" }
  ```
- **Response Error**:
  ```json
  { "status": "error", "message": "Deskripsi error" }
  ```

### Endpoint Admin (Session Required)

#### `ai_analysis.php?action=analyze`
- **Method**: GET
- **Deskripsi**: Jalankan analisis AI pada semua data survei yang belum dianalisis
- **Session Required**: `$_SESSION['admin_id']`
- **Response**:
  ```json
  { "success": true, "message": "Analisis selesai. X data berhasil dianalisis." }
  ```

#### `ai_analysis.php?action=stats`
- **Method**: GET
- **Deskripsi**: Dapatkan statistik hasil analisis AI
- **Session Required**: `$_SESSION['admin_id']`
- **Response**:
  ```json
  {
    "category_distribution": { "kesiswaan": 5, "kurikulum": 3, ... },
    "recent_analyses": [ { "id": 1, "aspirasi": "...", "category": "...", ... } ],
    "total_analyzed": 20
  }
  ```

#### `admin.php?export`
- **Method**: GET
- **Deskripsi**: Download seluruh data survei sebagai CSV
- **Parameter**: None

#### `admin.php?delete_survey=X`
- **Method**: GET
- **Deskripsi**: Hapus data survei (super_admin only)

#### `admin.php?delete_admin=X`
- **Method**: GET
- **Deskripsi**: Hapus akun admin (super_admin only, tidak bisa hapus diri sendiri)

#### `admin.php?toggle_survey`
- **Method**: POST
- **Deskripsi**: Buka/tutup survei (admin/super_admin)

---

## Fitur AI Analysis

### Cara Kerja

1. **Trigger**: Admin mengklik "Jalankan Analisis" di dashboard
2. **Proses**: Sistem mengambil semua data survei dengan `analyzed = 0`
3. **API Call**: Teks aspirasi dikirim ke OpenRouter API menggunakan model `qwen/qwen3-coder-480b-a35b:free`
4. **Prompt Sistem**: Model diminta mengkategorikan teks ke 1 dari 5 kategori dan menentukan sentimen
5. **Response Parsing**: JSON dari API di-parse untuk mendapatkan category, sentiment, confidence, dan explanation
6. **Fallback**: Jika API gagal (timeout/error), sistem menggunakan keyword-based analysis
7. **Rate Limiting**: Delay 0.5 detik antar request untuk menghindari rate limit
8. **Penyimpanan**: Hasil disimpan ke database di kolom `sentiment`, `category`, `ai_confidence`, `ai_explanation`, `analyzed`, `analyzed_at`

### Prompt Sistem AI

```
Anda adalah asisten analisis teks. Tugas Anda adalah mengkategorikan teks aspirasi siswa ke dalam salah satu kategori berikut:
- kesiswaan (student affairs)
- kurikulum (curriculum)
- humas (public relations)
- sarana_prasarana (facilities and infrastructure)
- lainnya (others)

Juga tentukan sentimen: positive, negative, atau neutral.
Berikan confidence score (0.00-1.00) dan penjelasan singkat.

RESPON HANYA DALAM FORMAT JSON:
{"category": "...", "sentiment": "...", "confidence": 0.00, "explanation": "..."}
```

### Keyword Fallback

Jika API tidak tersedia, sistem menggunakan keyword matching:

| Kategori | Keyword |
|----------|---------|
| Kesiswaan | siswa, osis, ekskul, tata tertib, kedisiplinan, seragam, perlombaan |
| Kurikulum | pelajaran, guru mengajar, kurikulum, ujian, tugas, nilai, mapel, jadwal |
| Humas | informasi, publikasi, sosialisasi, website, humas, kegiatan sekolah |
| Sarana Prasarana | toilet, kelas, kursi, meja, ac, kipas, laboratorium, perpustakaan, wifi, proyektor |
| Lainnya | (jika tidak ada keyword yang cocok) |

---

## Keamanan

### Authentication
- Password di-hash menggunakan bcrypt via `password_hash()` / `password_verify()`
- Session-based authentication dengan PHP sessions
- Logout otomatis dengan `session_destroy()`

### Authorization
- Role-based access control (RBAC) dengan 3 level: `super_admin`, `admin`, `staff`
- Setiap aksi sensitive diperiksa role-nya sebelum dieksekusi
- Admin tidak bisa menghapus akun sendiri

### Input Validation
- Prepared statements (PDO) untuk semua query SQL → prevent SQL injection
- `htmlspecialchars()` untuk output → prevent XSS
- Validasi tipe file upload (hanya JPG, PNG, GIF, PDF, DOC, DOCX)
- Validasi role hanya dari nilai yang diizinkan

### File Upload
- File disimpan dengan prefix timestamp untuk menghindari konflik nama
- Hanya ekstensi tertentu yang diizinkan
- Direktori `uploads/` terpisah dari file aplikasi

### Best Practice Notes
- **Jangan expose** `config.php` atau `ai_analysis.php` ke publik (API key)
- **Ganti password default** `admin/admin123` segera setelah instalasi
- **Rotate OpenRouter API key** secara berkala
- **Aktifkan HTTPS** di production
- **Batasi akses ke folder uploads** via `.htaccess` jika perlu

---

## Teknologi

### Backend
| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| PHP | 7.4+ | Bahasa pemrograman backend |
| MySQL / MariaDB | 5.7+ / 10.3+ | Database |
| PDO | - | Database abstraction layer |
| OpenRouter API | - | AI analysis services |

### Frontend
| Teknologi | Versi | Kegunaan | Sumber |
|-----------|-------|----------|--------|
| HTML5 | - | Struktur halaman | - |
| CSS3 | - | Styling kustom | - |
| Vanilla JavaScript | ES6+ | Interaktivitas | - |
| FontAwesome | 6.4.0 | Ikon | CDN |
| Google Fonts | - | Ranchers + DynaPuff | CDN |
| Chart.js | 4.4.0 | Grafik analisis AI | CDN |

### Tools
| Tool | Kegunaan |
|------|----------|
| XAMPP | Development environment (Apache + MySQL + PHP) |
| phpMyAdmin | Database management |

---

## Pemeliharaan

### Backup Database
```sql
mysqldump -u root asfour_survey > backup_asfour_survey.sql
```

### Reset Data Survei
```sql
TRUNCATE TABLE surveys;
TRUNCATE TABLE admin_logs;
```

### Reset Admin (jika lupa password)
```sql
-- Password: admin123 (ganti dengan hash bcrypt baru)
UPDATE admins SET username = 'admin', password = '$2y$10$nO3d4eg012oYC7l48P2fWuMwpSv2.0x.K/nRoS9hrLq309Z7tazDq' WHERE id = 1;
```
Atau generate hash baru:
```bash
php -r "echo password_hash('password_baru', PASSWORD_DEFAULT);"
```

### Update API Key OpenRouter
Buka `ai_analysis.php` dan ganti nilai konstanta `OPENROUTER_API_KEY`.

### Mengganti Logo & Banner
Ganti file `logo.png` dan `banner.png` di root folder.

### Mengganti Backsound
Ganti file `backsound1.mp3` atau ubah URL CDN di `index.php`.

---

## Troubleshooting

### "Database Connection Failed"
- Pastikan MySQL sedang berjalan
- Periksa konfigurasi di `config.php`
- Pastikan database `asfour_survey` sudah dibuat

### "Survey Belum Dimulai" padahal seharusnya open
- Login ke admin dashboard
- Buka tab **Settings**
- Set survey status ke **"Buka"**

### Login gagal "Username atau password salah!"
- Periksa username dan password
- Jika lupa password, reset via SQL (lihat bagian [Reset Admin](#reset-admin-jika-lupa-password))

### Gagal upload file
- Pastikan folder `uploads/` writable
- Periksa ukuran file (max 2MB)
- Periksa tipe file (hanya JPG, PNG, GIF, PDF, DOC, DOCX)

### AI Analysis tidak berfungsi
- Periksa koneksi internet
- Periksa API key di `ai_analysis.php`
- Cek log error PHP
- Sistem akan otomatis fallback ke keyword-based analysis jika API gagal

### Error "Undefined array key" atau warning PHP
- Pastikan PHP version sesuai (7.4+)
- Sesuaikan `error_reporting` di `php.ini` jika perlu

### Halaman tidak bisa diakses
- Pastikan web server (Apache) berjalan
- Periksa path URL (case sensitive di Linux)
- Pastikan file tidak corrupt

---

## Lisensi

Hak cipta dilindungi. Aplikasi ini dikembangkan untuk keperluan internal sekolah.

---

## Kontak & Dukungan

Untuk pertanyaan, saran, atau laporan bug, silakan hubungi admin sistem atau buka issue di repository proyek ini.

---

*Dibuat dengan ❤️ untuk ASFOUR 2026 - Aspirasi Four*
#   A S F O U R - 2 0 2 6  
 