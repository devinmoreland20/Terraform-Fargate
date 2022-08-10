packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "centos" {
  image  = "centos:latest"
  commit = true
}

build {
  name = "centos-devin"
  sources = [
    "source.docker.centos"
  ]

    post-processor "docker-tag" {
    repository = "devin"
    tags       = ["centos"]
    only       = ["docker.centos"]
  }
}

