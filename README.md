# ASFOUR 2026

**ASFOUR 2026 Website** adalah website untuk mengumpulkan, mengelola, dan menganalisis aspirasi dari siswa, guru, dan warga sekolah.
Aplikasi ini dibangun menggunakan **PHP Native**, **MySQL**, dan dilengkapi fitur **AI Analysis** berbasis **OpenRouter API**.

---

## Preview

* Landing page interaktif
* Form survei multi-step
* Dashboard admin lengkap
* AI sentiment & category analysis
* Export CSV
* Media gallery upload

---

# Daftar Isi

* [Fitur](#fitur)
* [Persyaratan Sistem](#persyaratan-sistem)
* [Instalasi](#instalasi)
* [Struktur Database](#struktur-database)
* [Struktur File](#struktur-file)
* [Role & Hak Akses](#role--hak-akses)
* [Cara Penggunaan](#cara-penggunaan)
* [API & Endpoint](#api--endpoint)
* [Fitur AI Analysis](#fitur-ai-analysis)
* [Keamanan](#keamanan)
* [Teknologi](#teknologi)
* [Pemeliharaan](#pemeliharaan)
* [Troubleshooting](#troubleshooting)
* [Lisensi](#lisensi)

---

# Fitur

## Publik (Pengguna Umum)

### Landing Page

* Tampilan pembuka modern
* Logo dan banner sekolah
* Tombol mulai survei

### Form Survei Multi-Step

Alur survei terdiri dari:

1. Landing
2. Loading
3. Form
4. Thank You

### Role Pengguna

Pilihan role:

* Guru
* Siswa
* Warga Sekolah
* Umum

### Angkatan Khusus Siswa

Dropdown angkatan otomatis muncul saat memilih role **Siswa**:

* A'24
* A'25
* A'26

### Upload File

Mendukung upload:

* JPG
* PNG
* GIF
* PDF
* DOC
* DOCX

### Preview File

Pengguna dapat melihat file sebelum submit.

### Background Music

* `backsound1.mp3` lokal
* Musik CDN Pixabay

### Responsive Design

Tampilan mobile-friendly dan desktop-friendly.

---

## Admin Dashboard

### Overview

Statistik jumlah responden:

* Total
* Siswa
* Guru
* Warga Sekolah

### Survey Responses

* Tabel seluruh aspirasi
* Search
* Filter data
* Export CSV

### Media Gallery

Preview file upload:

* Gambar inline
* PDF embed
* Download file lain

### AI Analysis

* Analisis AI otomatis
* Grafik distribusi kategori
* Tabel hasil analisis

### Settings

* Toggle buka/tutup survei
* Khusus `admin` dan `super_admin`

### Admin Management

* Tambah admin
* Hapus admin
* Khusus `super_admin`

### Activity Logs

Menyimpan aktivitas admin.

### Sidebar Navigation

* Responsive sidebar
* Hamburger menu mobile

---

## AI Analysis

### Fitur AI

* Klasifikasi kategori otomatis
* Sentiment analysis
* Confidence score
* Keyword fallback
* Visualisasi Chart.js
* Rate limiting API

### Kategori AI

* Kesiswaan
* Kurikulum
* Humas
* Sarana Prasarana
* Lainnya

### Sentiment

* Positive
* Negative
* Neutral

---

# Persyaratan Sistem

| Komponen | Versi |
| -------- | ----- |
| Apache   | 2.4+  |
| PHP      | 7.4+  |
| MySQL    | 5.7+  |
| MariaDB  | 10.3+ |

## PHP Extension

```txt
pdo_mysql
session
json
fileinfo
```

## Browser Support

* Chrome
* Firefox
* Edge
* Safari

## Koneksi Internet

Diperlukan untuk:

* CDN
* Google Fonts
* Chart.js
* OpenRouter API

---

# Instalasi

## 1. Clone / Download Project

Letakkan project di folder web server:

```bash
C:\xampp\htdocs\ASFOUR 2026\
```

---

## 2. Setup Database

### Fresh Install

Import file `db.sql`:

```sql
SOURCE C:/xampp/htdocs/ASFOUR 2026/db.sql;
```

Jika perlu menambahkan kolom AI:

```sql
SOURCE C:/xampp/htdocs/ASFOUR 2026/migration_ai_analysis.sql;
```

---

### Update Database Lama

```sql
SOURCE C:/xampp/htdocs/ASFOUR 2026/migration_ai_analysis.sql;
```

---

## 3. Konfigurasi Database

Edit file `config.php`:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'asfour_survey');
define('DB_USER', 'root');
define('DB_PASS', '');
```

---

## 4. Konfigurasi OpenRouter API

Edit file `ai_analysis.php`:

```php
define('OPENROUTER_API_KEY', 'sk-or-v1-xxxxxxxxxxxx');
```

Daftar API key:

```txt
https://openrouter.ai/
```

---

## 5. Permission Folder Upload

```bash
chmod 755 uploads/
```

Windows:

* Pastikan folder tidak read-only

---

## 6. Akses Aplikasi

| Halaman | URL                                        |
| ------- | ------------------------------------------ |
| Public  | `http://localhost/ASFOUR%202026/`          |
| Admin   | `http://localhost/ASFOUR%202026/admin.php` |

---

## 7. Login Default

| Username | Password | Role        |
| -------- | -------- | ----------- |
| admin    | admin123 | Super Admin |

> Segera ganti password setelah login pertama.

---

# Struktur Database

## Table `surveys`

Menyimpan data aspirasi responden.

| Kolom          | Tipe               | Keterangan       |
| -------------- | ------------------ | ---------------- |
| id             | INT AUTO_INCREMENT | Primary Key      |
| role           | VARCHAR(50)        | Role responden   |
| angkatan       | VARCHAR(20)        | Khusus siswa     |
| aspirasi       | TEXT               | Isi aspirasi     |
| file_path      | VARCHAR(255)       | File upload      |
| created_at     | TIMESTAMP          | Waktu submit     |
| sentiment      | ENUM               | Hasil sentiment  |
| category       | ENUM               | Kategori AI      |
| ai_confidence  | DECIMAL(3,2)       | Confidence score |
| ai_explanation | TEXT               | Penjelasan AI    |
| analyzed       | TINYINT(1)         | Status analisis  |
| analyzed_at    | TIMESTAMP          | Waktu analisis   |

---

## Table `admins`

| Kolom      | Tipe               | Keterangan              |
| ---------- | ------------------ | ----------------------- |
| id         | INT AUTO_INCREMENT | Primary Key             |
| username   | VARCHAR(50)        | Username login          |
| password   | VARCHAR(255)       | Hash bcrypt             |
| role       | ENUM               | super_admin/admin/staff |
| created_at | TIMESTAMP          | Dibuat pada             |

---

## Table `settings`

| Kolom         | Tipe              |
| ------------- | ----------------- |
| id            | INT               |
| survey_status | ENUM(open/closed) |

---

## Table `admin_logs`

| Kolom      | Tipe               |
| ---------- | ------------------ |
| id         | INT AUTO_INCREMENT |
| admin_id   | INT                |
| action     | VARCHAR(255)       |
| details    | TEXT               |
| created_at | TIMESTAMP          |

---

# Struktur File

```txt
ASFOUR 2026/
│
├── .qodo/
├── scratch/
├── uploads/
│
├── admin.php
├── ai_analysis.php
├── backsound1.mp3
├── banner.png
├── belum_mulai.php
├── config.php
├── db.sql
├── index.php
├── logo.png
├── migration_ai_analysis.sql
├── submit_survey.php
└── README.md
```

---

## Deskripsi File

| File                        | Fungsi                 |
| --------------------------- | ---------------------- |
| `index.php`                 | Aplikasi survei publik |
| `admin.php`                 | Dashboard admin        |
| `config.php`                | Koneksi database       |
| `db.sql`                    | Schema database        |
| `submit_survey.php`         | Handler submit survei  |
| `ai_analysis.php`           | Handler AI analysis    |
| `belum_mulai.php`           | Halaman survei ditutup |
| `migration_ai_analysis.sql` | Migrasi AI             |

---

# Role & Hak Akses

| Fitur            | super_admin | admin | staff |
| ---------------- | :---------: | :---: | :---: |
| Overview         |      ✅      |   ✅   |   ✅   |
| Survey Responses |      ✅      |   ✅   |   ✅   |
| Media Gallery    |      ✅      |   ✅   |   ✅   |
| AI Analysis      |      ✅      |   ✅   |   ✅   |
| Export CSV       |      ✅      |   ✅   |   ✅   |
| Toggle Survey    |      ✅      |   ✅   |   ❌   |
| Hapus Survei     |      ✅      |   ❌   |   ❌   |
| Kelola Admin     |      ✅      |   ❌   |   ❌   |
| Activity Logs    |      ✅      |   ❌   |   ❌   |

---

# Cara Penggunaan

## Publik

1. Buka `index.php`
2. Klik tombol **MULAI**
3. Tunggu loading
4. Isi form
5. Upload file jika perlu
6. Klik **KIRIM**
7. Selesai

---

## Admin Dashboard

1. Login ke `admin.php`
2. Gunakan sidebar menu:

   * Overview
   * Survey Responses
   * Media Gallery
   * AI Analysis
   * Settings
   * Admin Management
   * Activity Logs

---

## Export CSV

1. Masuk tab **Survey Responses**
2. Klik **Export CSV**

---

## Menjalankan AI Analysis

1. Masuk tab **AI Analysis**
2. Klik **Jalankan Analisis**
3. Tunggu proses selesai

---

# API & Endpoint

## Public Endpoint

### `submit_survey.php`

| Method       | POST                |
| ------------ | ------------------- |
| Content-Type | multipart/form-data |

### Parameter

| Parameter | Required | Deskripsi      |
| --------- | -------- | -------------- |
| role      | ✅        | Role pengguna  |
| angkatan  | ❌        | Angkatan siswa |
| aspirasi  | ✅        | Isi aspirasi   |
| file      | ❌        | File upload    |

### Response Success

```json
{
  "status": "success"
}
```

### Response Error

```json
{
  "status": "error",
  "message": "Deskripsi error"
}
```

---

## Admin Endpoint

### `ai_analysis.php?action=analyze`

Menjalankan AI analysis.

### Response

```json
{
  "success": true,
  "message": "Analisis selesai"
}
```

---

### `ai_analysis.php?action=stats`

Mengambil statistik AI.

```json
{
  "category_distribution": {},
  "recent_analyses": [],
  "total_analyzed": 20
}
```

---

### `admin.php?export`

Export CSV survei.

---

### `admin.php?delete_survey=X`

Hapus data survei.

---

### `admin.php?delete_admin=X`

Hapus admin.

---

### `admin.php?toggle_survey`

Buka/tutup survei.

---

# Fitur AI Analysis

## Workflow

1. Admin klik tombol analisis
2. Sistem mengambil data belum dianalisis
3. Data dikirim ke OpenRouter API
4. AI menentukan kategori dan sentimen
5. Sistem parsing JSON response
6. Jika API gagal → fallback keyword
7. Hasil disimpan ke database

---

## Model AI

```txt
qwen/qwen3-coder-480b-a35b:free
```

---

## Prompt Sistem

```json
{
  "category": "...",
  "sentiment": "...",
  "confidence": 0.00,
  "explanation": "..."
}
```

---

## Keyword Fallback

| Kategori  | Keyword                 |
| --------- | ----------------------- |
| Kesiswaan | siswa, osis, ekskul     |
| Kurikulum | pelajaran, ujian, nilai |
| Humas     | informasi, website      |
| Sarana    | toilet, kelas, wifi     |
| Lainnya   | default                 |

---

# Keamanan

## Authentication

* Password bcrypt
* PHP session authentication
* Session destroy logout

## Authorization

* RBAC
* Role validation
* Self-delete prevention

## Input Validation

* PDO prepared statement
* `htmlspecialchars()`
* File validation
* Role validation

## File Upload

* Timestamp filename
* Extension whitelist
* Separate upload directory

---

## Best Practice

* Jangan expose `config.php`
* Ganti password default
* Rotate API key
* Gunakan HTTPS production
* Batasi akses folder uploads

---

# Teknologi

## Backend

| Teknologi      | Kegunaan       |
| -------------- | -------------- |
| PHP            | Backend        |
| MySQL          | Database       |
| PDO            | Database layer |
| OpenRouter API | AI service     |

---

## Frontend

| Teknologi      | Kegunaan       |
| -------------- | -------------- |
| HTML5          | Struktur       |
| CSS3           | Styling        |
| JavaScript ES6 | Interaktivitas |
| FontAwesome    | Icon           |
| Google Fonts   | Typography     |
| Chart.js       | Grafik         |

---

# Pemeliharaan

## Backup Database

```bash
mysqldump -u root asfour_survey > backup_asfour_survey.sql
```

---

## Reset Data

```sql
TRUNCATE TABLE surveys;
TRUNCATE TABLE admin_logs;
```

---

## Reset Password Admin

```sql
UPDATE admins 
SET username = 'admin',
password = '$2y$10$nO3d4eg012oYC7l48P2fWuMwpSv2.0x.K/nRoS9hrLq309Z7tazDq'
WHERE id = 1;
```

Generate hash baru:

```bash
php -r "echo password_hash('password_baru', PASSWORD_DEFAULT);"
```

---

## Update API Key

Edit:

```txt
ai_analysis.php
```

---

## Ganti Logo & Banner

Replace:

* `logo.png`
* `banner.png`

---

## Ganti Backsound

Replace:

* `backsound1.mp3`

---

# Troubleshooting

## Database Connection Failed

* Pastikan MySQL berjalan
* Cek `config.php`
* Pastikan database tersedia

---

## Survey Tidak Bisa Dibuka

* Login admin
* Masuk tab Settings
* Set status survey → Open

---

## Login Gagal

* Cek username/password
* Reset password jika lupa

---

## Upload File Gagal

* Cek permission folder
* Maksimum 2MB
* Pastikan ekstensi valid

---

## AI Analysis Error

* Cek internet
* Cek API key
* Cek PHP error log
* Sistem fallback otomatis

---

## Warning PHP

* Gunakan PHP 7.4+
* Sesuaikan `error_reporting`

---

## Halaman Tidak Bisa Diakses

* Pastikan Apache berjalan
* Cek URL
* Pastikan file tidak corrupt

---

# Lisensi

Hak cipta dilindungi.
Aplikasi ini dikembangkan untuk kebutuhan internal sekolah.

---

# Kontak & Dukungan

Jika menemukan bug atau ingin memberikan saran:

* Hubungi admin sistem
* Buat issue di repository project

---

## Dibuat Untuk ASFOUR 2026

**ASFOUR - Aspirasi Four**
Sistem survei aspirasi sekolah berbasis web dengan integrasi AI analysis.
