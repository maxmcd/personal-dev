
provider "google" {
  project     = "media-9x16"
  region      = "us-east4"
}

resource "google_compute_address" "me" {
  name = "dev-instance"
}

resource "google_compute_instance" "me" {
  name         = "dev-instance"
  machine_type = "n1-standard-1"
  zone         = "us-east4-c"


  boot_disk {
    initialize_params {
      image = "packer-1541269885"
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = "${google_compute_address.me.address}"
    }
  }
}
