
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pull de l'image depuis Docker Hub
resource "docker_image" "cv_image" {
  name = "docker.io/ichrakyhy/cv-onepage:latest"
}

# Création du conteneur
resource "docker_container" "cv_container" {
  name  = "moncv"
  image = docker_image.cv_image.image_id
  ports {
    internal = 80
    external = 8585
  }
}

# Output pour l'URL d'accès
output "access_url" {
  value = "http://10.0.0.10:8585"
}
