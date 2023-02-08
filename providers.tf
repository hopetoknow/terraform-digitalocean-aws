provider "digitalocean" {
  token = var.digitalocean_access_token
}

provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}