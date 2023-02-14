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

variable "droplet_count" {
  type = number
  description = "Number of droplets to create"
}

variable "personal_domain_prefix" { 
  type = string 
  description = "The personal prefix for DNS records"
}

variable "password_parameters" {
  type = object({
    length = number
	  special = bool
  })
  description = "The generated password parameters"
}

variable "droplet_parameters" {
  type = object({
    image = string
    name = string
    vcpus = number
	  memory = number
	  disk = number
  })
  description = "The created droplet parameters"
}

variable "droplet_connection" {
  type = object({
    type = string
    user = string
    agent = bool
  })
  description = "The parameters of connection block that describe how to access the remote resource"
}

variable "aws_parameters" {
  type = object({
    provider_region = string # AWS region where the provider will operate        
    provider_access_key = string # AWS access key ID
    provider_secret_key = string # AWS secret access key
    zone_name = string # The name of the hosted zone 
    record_type = string # The record type
    record_ttl = number # The TTL of the record
  })  
}