resource "google_compute_subnetwork" "primary-us-central1" {
  provider = "google.de"

  name          = "primary-us-central1"
  ip_cidr_range = "10.28.0.0/16"
  network       = "${google_compute_network.primary.self_link}"
  region        = "us-central1"
}

resource "google_compute_network" "primary" {
  provider = "google.de"

  name                    = "primary"
  auto_create_subnetworks = false
}
