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

resource "null_resource" "doker_vol" {
  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"
  }
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red"
}

resource "docker_container" "nodered_container" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path = "/home/nhk/Desktop/MT Certified in Terraform/noderedvol/"
  }
}



