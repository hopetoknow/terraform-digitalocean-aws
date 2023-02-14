resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = var.email_tag
  public_key = file(var.public_ssh_key_file_path)
}

resource "random_password" "password" {
  count = var.droplet_count
  length = var.password_parameters.length
	special = var.password_parameters.special
}

resource "digitalocean_droplet" "web" {
  count = var.droplet_count
  image  = var.droplet_parameters.image
  name   = "${var.droplet_parameters.name}-${count.index + 1}"
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size   = element(data.digitalocean_sizes.main.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.existing_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = ["devops", var.email_tag]

  provisioner "remote-exec" {
      connection {
      type     = var.droplet_connection.type
      user     = var.droplet_connection.user
      private_key = file(var.private_ssh_key_file_path)
      host     = self.ipv4_address
      agent    = var.droplet_connection.agent
    }

    inline = [
      "echo \"${var.droplet_connection.user}:${random_password.password[count.index].result}\" | sudo chpasswd"
    ]
  }
}

resource "aws_route53_record" "my_dns_record" {
  count = var.droplet_count
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.personal_domain_prefix}-${count.index + 1}"
  type    = var.aws_parameters.record_type
  ttl     = var.aws_parameters.record_ttl
  records = [digitalocean_droplet.web[count.index].ipv4_address]
}
