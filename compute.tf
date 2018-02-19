variable "instance_name" {
  default = "docker-host"
}

variable "instance_type" {
  default = "f1-micro"
}

variable "instance_zone" {
  default = "us-east1-b"
}

variable "instance_image" {
  default = "debian-9-stretch-v20180206"
}

variable "ssh_pub_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

resource "google_compute_instance" "docker_host" {
  name         = "${var.instance_name}"
  machine_type = "${var.instance_type}"
  zone         = "${var.instance_zone}"
  project      = "${var.project_id}"
  depends_on   = ["google_project.mediawiki"]

  boot_disk {
    initialize_params {
      image = "${var.instance_image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {
    sshKeys = "root:${file(var.ssh_pub_key_file)}"
  }

  metadata_startup_script = "${file("scripts/provision.sh")}"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/root/docker-compose.yml"
  }

  provisioner "file" {
    source      = ".env"
    destination = "/root/.env"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /root",
      "source .env && docker-compose up -d",
    ]
  }
}
