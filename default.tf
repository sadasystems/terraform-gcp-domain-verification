output "endpoint" { value = google_dns_record_set.default.name }

variable "network" {}
variable "subnetwork" {}
variable "region" {}
variable "dns_zone" {}
variable "dns_zone_name" {}
variable "verification_file" {}

variable "labels" { default = [] }

resource "google_compute_instance" "default" {
  name = "domain-verification"
  machine_type = "e2-standard-2"
  zone = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size = 10
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {}
  }

  metadata_startup_script = templatefile(
    "${path.module}/init.sh",
    {
      bucket = google_storage_bucket.default.name,
      file = google_storage_bucket_object.default.name,
    }
  )

  allow_stopping_for_update = false

  tags = [
    "http-server",
  ]

  service_account {
    scopes = [
      "storage-ro",
    ]
  }

  labels = var.labels
}

resource "google_dns_record_set" "default" {
  name = var.dns_zone
  type = "A"
  ttl  = 300

  managed_zone = var.dns_zone_name
  rrdatas = [
    google_compute_instance.default.network_interface.0.access_config.0.nat_ip,
  ]
}

resource "google_storage_bucket" "default" {
  name          = "domain-verification"
  location      = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "default" {
  name   = var.verification_file
  source = var.verification_file
  bucket = google_storage_bucket.default.name
}
