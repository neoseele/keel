provider "google" {
  version = "~> 2.9.0"
  region  = var.region
}

provider "google-beta" {
  version = "~> 2.9.0"
  region  = var.region
}

locals {
  cluster_type = "simple-regional"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = "cft-gke-test-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  project       = var.project_id
  name          = "cft-gke-test-${random_string.suffix.result}"
  ip_cidr_range = "10.0.0.0/17"
  region        = "us-east1"
  network       = google_compute_network.main.self_link

  secondary_ip_range {
    range_name    = "cft-gke-test-pods-${random_string.suffix.result}"
    ip_cidr_range = "192.168.0.0/18"
  }

  secondary_ip_range {
    range_name    = "cft-gke-test-services-${random_string.suffix.result}"
    ip_cidr_range = "192.168.64.0/18"
  }
}



module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "4.1.0"
  project_id        = var.project_id
  name              = "${local.cluster_type}-cluster-${random_string.suffix.result}"
  regional          = true
  region            = var.region
  network                        = google_compute_network.main.name
  subnetwork                     = google_compute_subnetwork.main.name
  ip_range_pods                  = google_compute_subnetwork.main.secondary_ip_range[0].range_name
  ip_range_services              = google_compute_subnetwork.main.secondary_ip_range[1].range_name
}

data "google_client_config" "default" {
}


