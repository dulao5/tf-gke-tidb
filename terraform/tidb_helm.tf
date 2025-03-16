provider "helm" {
  kubernetes {
    host                   = google_container_cluster.tidb.endpoint
    cluster_ca_certificate = base64decode(google_container_cluster.tidb.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

resource "helm_release" "tidb_operator" {
  name       = "tidb-operator"
  repository = "https://charts.pingcap.org/"
  chart      = "tidb-operator"
  namespace  = "tidb-admin"
  create_namespace = true
}

resource "helm_release" "tidb_cluster" {
  name       = "tidb-cluster"
  #chart      = "pingcap/tidb-cluster"
  #repository = "https://charts.pingcap.org/"
  chart      = "${path.module}/../helm/tidb-operator"
  namespace  = "tidb-cluster"
  create_namespace = true
  values = [
    file("../helm/tidb-cluster/values.yaml")
  ]
}