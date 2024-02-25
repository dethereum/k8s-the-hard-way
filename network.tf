resource "google_compute_network" "k8s_vpc_network" {
  project                 = var.project_id
  name                    = "k8s-vpc-network"
  auto_create_subnetworks = false

  depends_on = [
    google_project_service.compute_engine_api
  ]
}

resource "google_compute_subnetwork" "k8s_vpc_subnetwork" {
  name          = "k8s-vpc-subnetwork"
  ip_cidr_range = "10.240.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.k8s_vpc_network.id
}

resource "google_compute_firewall" "k8s_internal_firewall" {
  name    = "k8s-internal-firewall"
  network = google_compute_network.k8s_vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }


  allow {
    protocol = "udp"
  }

  source_ranges = ["10.240.0.0/24", "10.200.0.0/16"]
}

resource "google_compute_firewall" "k8s_external_firewall" {
  name    = "k8s-external-firewall"
  network = google_compute_network.k8s_vpc_network.name

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "k8s_ip_address" {
  name         = "k8s-ip-address"
  address_type = "EXTERNAL"

  depends_on = [
    google_project_service.compute_engine_api
  ]
}