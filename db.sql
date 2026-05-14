-- Membuat database utama
CREATE DATABASE IF NOT EXISTS asfour_survey;
USE asfour_survey;

-- Tabel untuk menyimpan data survei dari responden
CREATE TABLE IF NOT EXISTS surveys (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role VARCHAR(50) NOT NULL,
    angkatan VARCHAR(20) DEFAULT NULL,
    aspirasi TEXT NOT NULL,
    file_path VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sentiment ENUM('positive', 'negative', 'neutral') DEFAULT NULL,
    category ENUM('kesiswaan', 'kurikulum', 'humas', 'sarana_prasarana', 'lainnya') DEFAULT NULL,
    ai_confidence DECIMAL(3,2) DEFAULT NULL,
    ai_explanation TEXT DEFAULT NULL,
    analyzed TINYINT(1) DEFAULT 0,
    analyzed_at TIMESTAMP NULL
);

-- Tabel untuk akun admin (super_admin, admin, staff)
CREATE TABLE IF NOT EXISTS admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('super_admin', 'admin', 'staff') DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel untuk pengaturan global aplikasi
CREATE TABLE IF NOT EXISTS settings (
    id INT PRIMARY KEY DEFAULT 1,
    survey_status ENUM('open', 'closed') DEFAULT 'open',
    CHECK (id = 1)
);

-- Tabel untuk mencatat aktivitas admin
CREATE TABLE IF NOT EXISTS admin_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT,
    action VARCHAR(255) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE SET NULL
);

-- Data awal: status survei default = buka
INSERT IGNORE INTO settings (id, survey_status) VALUES (1, 'open');

-- Akun super admin default (username: admin, password: admin123)
INSERT IGNORE INTO admins (username, password, role) VALUES ('admin', '$2y$10$nO3d4eg012oYC7l48P2fWuMwpSv2.0x.K/nRoS9hrLq309Z7tazDq', 'super_admin');
