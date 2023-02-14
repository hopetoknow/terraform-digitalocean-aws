provider "digitalocean" {
	token = var.digitalocean_access_token
}

provider "aws" {
  region = var.aws_parameters.provider_region
  access_key = var.aws_parameters.provider_access_key
  secret_key = var.aws_parameters.provider_secret_key
}