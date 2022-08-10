packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:latest"
  commit = true
}

build {
  name = "ubuntu-devin"
  sources = [
    "source.docker.ubuntu"
  ]
  
  post-processor "docker-tag" {
    repository = "devin"
    tags       = ["ubuntu"]
    only       = ["docker.ubuntu"]
  }
}

