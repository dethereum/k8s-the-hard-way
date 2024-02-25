resource "google_project_service" "cloud_resource_manager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
}


resource "google_project_service" "compute_engine_api" {
  project = var.project_id
  service = "compute.googleapis.com"

  depends_on = [
    google_project_service.cloud_resource_manager
  ]
}