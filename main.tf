terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.30.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17.0"
    }
  }
}
