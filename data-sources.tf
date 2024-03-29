data "digitalocean_ssh_key" "existing_ssh_key" {
  name = var.digitalocean_existing_ssh_key_name
}

data "digitalocean_sizes" "balancer" {
  filter {
    key    = "vcpus"
    values = [var.balancer_droplet_parameters.vcpus]
  }

  filter {
    key    = "memory"
    values = [var.balancer_droplet_parameters.memory]
  }

  filter {
    key    = "disk"
    values = [var.balancer_droplet_parameters.disk]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

data "digitalocean_sizes" "app" {
  filter {
    key    = "vcpus"
    values = [var.app_droplet_parameters.vcpus]
  }

  filter {
    key    = "memory"
    values = [var.app_droplet_parameters.memory]
  }

  filter {
    key    = "disk"
    values = [var.app_droplet_parameters.disk]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}

data "aws_route53_zone" "primary" {
  name = var.aws_parameters.zone_name
}
