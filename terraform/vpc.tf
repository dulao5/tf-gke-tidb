resource "google_compute_network" "tidb_vpc" {
  name                    = "tidb-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tidb_subnet" {
  name          = "tidb-subnet"
  ip_cidr_range = "10.10.0.0/16"
  region        = var.region
  network       = google_compute_network.tidb_vpc.id
  private_ip_google_access = true
}