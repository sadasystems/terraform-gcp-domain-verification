variable project { default = "sada-slava-maslennikov" }
variable region { default = "us-central1" }

provider "google" {
  project = var.project
  region = var.region
}

module "domain-verification" {
  source = "../"

  network = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.default.self_link
  region = var.region
  dns_zone = google_dns_managed_zone.default.dns_name
  dns_zone_name = google_dns_managed_zone.default.name
  verification_file = "googleeb2165d3b3416dd2.html"
}

resource "google_compute_network" "default" {
  name                    = "network"
  auto_create_subnetworks = false
  project                 = var.project
}

resource "google_compute_subnetwork" "default" {
  name = "subnet"

  ip_cidr_range = "10.0.0.0/24"
  network = google_compute_network.default.self_link

  region  = var.region
  project = var.project
}

resource "google_dns_managed_zone" "default" {
  name        = "zone"
  dns_name    = "${var.project}.allweretaken.xyz."
}

resource "google_storage_bucket" "tfstate" {
  name     = "${var.project}-tfstate"
  location = upper(var.region)

  versioning {
    enabled = true
  }
}

terraform {
  required_version = "~> 0.12.29"

  backend "gcs" {
    bucket = "sada-slava-maslennikov-tfstate"
  }
}
