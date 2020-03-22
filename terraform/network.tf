resource "google_compute_network" "default" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "primary" {
  name                     = "${google_compute_network.default.name}-us-east-1"
  ip_cidr_range            = "10.142.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

output "network" {
  value = google_compute_subnetwork.primary.network
}

output "subnetwork_name" {
  value = google_compute_subnetwork.primary.name
}
