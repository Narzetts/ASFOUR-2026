<?php

// Konfigurasi koneksi database MySQL
define('DB_HOST', 'localhost');
define('DB_NAME', 'asfour_survey');
define('DB_USER', 'root');
define('DB_PASS', '');

// Membuat koneksi PDO ke database
try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME, DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Koneksi database gagal: " . $e->getMessage());
}

// Mencatat aktivitas admin ke dalam tabel admin_logs
function logActivity($pdo, $admin_id, $action, $details = "") {
    $stmt = $pdo->prepare("INSERT INTO admin_logs (admin_id, action, details) VALUES (?, ?, ?)");
    $stmt->execute([$admin_id, $action, $details]);
}

// Mengecek apakah survei sedang dibuka atau ditutup
function isSurveyOpen($pdo) {
    $stmt = $pdo->query("SELECT survey_status FROM settings WHERE id = 1");
    $result = $stmt->fetch();
    return $result['survey_status'] === 'open';
}
?>
