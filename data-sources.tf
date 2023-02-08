data "digitalocean_ssh_key" "some_ssh_key" {
  name = var.digitalocean_existing_ssh_key_name
}

data "digitalocean_sizes" "main" {
  filter {
    key    = "vcpus"
    values = [1]
  }

  filter {
    key    = "memory"
    values = [1024]
  }

  filter {
    key    = "disk"
    values = [25]
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
  name = var.aws_zone_name
}