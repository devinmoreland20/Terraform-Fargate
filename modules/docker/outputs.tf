#---- module/docker/outputs

output "image_name" {
  value = docker_image.centos.name
}
