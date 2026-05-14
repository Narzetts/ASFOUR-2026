<?php
require_once 'config.php';

header('Content-Type: application/json');

// Hanya menerima request POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

// Cek apakah survei sedang dibuka
if (!isSurveyOpen($pdo)) {
    echo json_encode(['status' => 'error', 'message' => 'Survey is currently closed']);
    exit;
}

$role = $_POST['role'] ?? '';
$angkatan = $_POST['angkatan'] ?? null;
$aspirasi = $_POST['aspirasi'] ?? '';
$filePath = null;

// Validasi field wajib: role dan aspirasi harus diisi
if (empty($role) || empty($aspirasi)) {
    echo json_encode(['status' => 'error', 'message' => 'Please fill all required fields']);
    exit;
}

// Proses upload file jika ada lampiran
if (isset($_FILES['file-upload']) && $_FILES['file-upload']['error'] === UPLOAD_ERR_OK) {
    $uploadDir = 'uploads/';
    if (!is_dir($uploadDir)) {
        mkdir($uploadDir, 0777, true);
    }

    $fileName = time() . '_' . basename($_FILES['file-upload']['name']);
    $targetPath = $uploadDir . $fileName;

    if (move_uploaded_file($_FILES['file-upload']['tmp_name'], $targetPath)) {
        $filePath = $targetPath;
    }
}

// Simpan data survei ke database
try {
    $stmt = $pdo->prepare("INSERT INTO surveys (role, angkatan, aspirasi, file_path) VALUES (?, ?, ?, ?)");
    $stmt->execute([$role, $angkatan, $aspirasi, $filePath]);

    echo json_encode(['status' => 'success', 'message' => 'Thank you for your feedback!']);
} catch (PDOException $e) {
    echo json_encode(['status' => 'error', 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
