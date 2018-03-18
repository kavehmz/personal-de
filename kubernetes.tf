resource "google_container_cluster" "primary" {
  provider           = "google.de"
  name               = "primary"
  zone               = "us-central1-a"
  cluster_ipv4_cidr  = "172.16.0.0/16"
  initial_node_count = 3
  min_master_version = "1.9.4-gke.1"
  enable_legacy_abac = false
  network            = "${google_compute_network.primary.name}"
  subnetwork         = "${google_compute_subnetwork.primary-us-central1.name}"

  node_config {
    machine_type = "f1-micro"
    disk_size_gb = "10"
    preemptible  = true
    oauth_scopes = "${var.default_auth}"

    labels {
      pool = "default"
    }

    tags = ["primary"]
  }
}

resource "google_container_node_pool" "micro" {
  provider = "google.de"
  name     = "micro"
  zone     = "us-central1-a"
  cluster  = "${google_container_cluster.primary.name}"

  autoscaling {
    min_node_count = 0
    max_node_count = 1
  }

  node_config {
    machine_type = "f1-micro"
    disk_size_gb = "20"
    preemptible  = true
    oauth_scopes = "${var.default_auth}"

    labels {
      pool = "micro"
    }

    tags = ["micro"]
  }
}
