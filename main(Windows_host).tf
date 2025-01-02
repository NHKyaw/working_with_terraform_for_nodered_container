terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.23.0"
    }
  }
}

provider "docker" {}

resource "random_string" "random" {
  count   = 1
  length  = 4
  special = false
  upper   = false

}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red"
}

resource "docker_container" "nodered_container" {

  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.image_id
  ports {
    internal = 1880
    external = 1880
  }
  volumes {
    container_path = "/data"
    host_path      = "C:/Users/NHK/Desktop/Terraform/noderedvol"
  }
}

resource "null_resource" "do_smth" {
  provisioner "local-exec" {
    command = <<EOT
if not exist .\\noderedvol mkdir .\\noderedvol
icacls .\\noderedvol /grant Everyone:F
EOT
  }
}

