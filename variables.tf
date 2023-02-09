variable "digitalocean_access_token" {
  type = string
  description = "DigitalOcean access token"
}

variable "public_ssh_key_file_path" {
  type = string
  description = "The path to the ssh public key on the local machine"
}

variable "private_ssh_key_file_path" {
  type = string
  description = "The path to the ssh private key on the local machine"
}

variable "digitalocean_existing_ssh_key_name" {
  type = string
  description = "The name of the ssh key not managed by Terraform"
}

variable "email_tag" {
  type = string
  description = "The email of the current user in a tag format"
}

variable "aws_access_key" {
  type = string
  description = "AWS access key ID"
}

variable "aws_secret_key" {
  type = string
  description = "AWS secret access key"
}

variable "aws_zone_name" {
  type = string
  description = "This is the name of the hosted zone"
}

variable "droplet_count" {
  type = number
  description = "Number of droplets to create"
}

variable "personal_domain_prefix" { 
  type = string 
  description = "The personal prefix for DNS records"
}
