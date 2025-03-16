output "gke_endpoint" {
  description = "GKE Cluster endpoint"
  value       = google_container_cluster.tidb.endpoint
}

output "gke_name" {
  value = google_container_cluster.tidb.name
}

output "tidb_internal_lb_ip" {
  value = helm_release.tidb_cluster.name # 后续可以通过 service 获取具体 LB 地址
}

//output "kms_key_id" {
//  value = google_kms_crypto_key.tidb_tls_key.id
//}
