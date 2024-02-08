terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.34.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.35.0"
    }
  }
}
