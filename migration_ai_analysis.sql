-- Migrasi: Menambahkan kolom analisis AI ke tabel surveys yang sudah ada
USE asfour_survey;

ALTER TABLE surveys 
ADD COLUMN IF NOT EXISTS sentiment ENUM('positive', 'negative', 'neutral') DEFAULT NULL AFTER file_path,
ADD COLUMN IF NOT EXISTS category ENUM('kesiswaan', 'kurikulum', 'humas', 'sarana_prasarana', 'lainnya') DEFAULT NULL AFTER sentiment,
ADD COLUMN IF NOT EXISTS ai_confidence DECIMAL(3,2) DEFAULT NULL AFTER category,
ADD COLUMN IF NOT EXISTS ai_explanation TEXT DEFAULT NULL AFTER ai_confidence,
ADD COLUMN IF NOT EXISTS analyzed TINYINT(1) DEFAULT 0 AFTER ai_explanation,
ADD COLUMN IF NOT EXISTS analyzed_at TIMESTAMP NULL AFTER analyzed;

-- Verifikasi kolom berhasil ditambahkan
SELECT 'AI Analysis columns added successfully!' as Status;

-- Lihat struktur tabel
DESCRIBE surveys;
