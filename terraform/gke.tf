resource "google_container_cluster" "tidb" {
  name     = "my-tidb-gke"
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnetwork

  node_locations = [
    "${var.region}-a",
    "${var.region}-b",
    "${var.region}-c"
  ]
}

resource "google_container_node_pool" "pd" {
  name       = "pd-pool"
  cluster    = google_container_cluster.tidb.name
  location   = var.region
  node_count = 1

  node_config {
    machine_type = var.node_type
    labels       = { role = "pd" }
    tags         = ["tidb-pd"]
  }
}

resource "google_container_node_pool" "tikv" {
  name       = "tikv-pool"
  cluster    = google_container_cluster.tidb.name
  location   = var.region
  node_count = 1

  node_config {
    machine_type = var.node_type
    labels       = { role = "tikv" }
    tags         = ["tidb-tikv"]
  }
}

resource "google_container_node_pool" "tidb" {
  name       = "tidb-pool"
  cluster    = google_container_cluster.tidb.name
  location   = var.region
  node_count = 1

  node_config {
    machine_type = var.node_type
    labels       = { role = "tidb" }
    tags         = ["tidb-tidb"]
  }
}