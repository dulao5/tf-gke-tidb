/*resource "google_kms_key_ring" "tidb" {
  name     = "dzg-tidb-keyring"
  location = var.region
}

resource "google_kms_crypto_key" "tidb_tls_key" {
  name            = "dzg-tidb-tls-key"
  key_ring        = google_kms_key_ring.tidb.id
  purpose         = "ENCRYPT_DECRYPT"
  rotation_period = "2592000s" # 每30天轮转
}*/