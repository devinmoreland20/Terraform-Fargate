#-----module/docker/main

resource "docker_image" "centos" {
  name = "centos:latest"

}
provider "docker" {

}
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.20.0"
    }
  }
}
