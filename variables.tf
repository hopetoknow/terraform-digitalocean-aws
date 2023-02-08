variable "digitalocean_access_token" {
  type = string
  description = "DigitalOcean access token"
}

variable "digitalocean_ssh_key_file_path" {
  type = string
  description = "Path to the key to export to DigitalOcean for SSH access."
}

variable "digitalocean_existing_ssh_key_name" {
  type = string
  description = "Name of the ssh key not managed by Terraform"
}

variable "email_tag" {
  type = string
  description = "Email of the current user in a tag format"
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
