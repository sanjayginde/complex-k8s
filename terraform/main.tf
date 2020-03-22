resource "google_container_cluster" "default" {
  name       = "${var.project}-cluster"
  location   = var.region
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.primary.name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # master_auth {
  #   username = ""
  #   password = ""

  #   client_certificate_config {
  #     issue_client_certificate = false
  #   }
  # }

  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}

resource "google_container_node_pool" "primary" {
  name       = "${var.project}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.default.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_endpoint" {
  value = google_container_cluster.default.endpoint
}

# output "cluster_certificate" {
#   value = base64decode(google_container_cluster.default.master_auth.0.client_certificate)
# }

# output "cluster_key" {
#   value = base64decode(google_container_cluster.default.master_auth.0.client_key)
# }
# output "cluster_ca_certificate" {
#   value = base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)
# }
