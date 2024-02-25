resource "google_compute_instance" "k8s_controllers" {
  count = length(var.controller_names)

  boot_disk {
    auto_delete = true
    device_name = "controller-${count.index}"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240223"
      size  = 200
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = false

  machine_type = "e2-standard-2"
  name         = "controller-${count.index}"

  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }

    network_ip  = "10.240.0.1${count.index}"
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = google_compute_subnetwork.k8s_vpc_subnetwork.id
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email = "86426181911-compute@developer.gserviceaccount.com"
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  shielded_instance_config {
    enable_integrity_monitoring = false
    enable_secure_boot          = false
    enable_vtpm                 = false
  }

  zone = "us-central1-a"
}