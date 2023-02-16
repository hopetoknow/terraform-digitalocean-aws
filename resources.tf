resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = var.email_tag
  public_key = file(var.public_ssh_key_file_path)
}

resource "random_password" "password" {
  count = length(local.dns_names)
  length = var.password_parameters.length
	special = var.password_parameters.special
}

resource "digitalocean_droplet" "web" {
  count = length(local.dns_names)
  image  = var.droplet_parameters.image
  name   = "${var.droplet_parameters.name}-${count.index + 1}"
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size   = element(data.digitalocean_sizes.main.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.existing_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = [var.team_tag, var.email_tag]

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

locals {
	dns_names = { for dev in var.devs : dev.prefix => "${dev.login}-${dev.prefix}" }
}

resource "aws_route53_record" "my_dns_record" {
  count = length(local.dns_names)
  zone_id = data.aws_route53_zone.primary.zone_id
  name = "${lookup(local.dns_names, var.devs[count.index].prefix)}"
  type    = var.aws_parameters.record_type
  ttl     = var.aws_parameters.record_ttl
  records = [digitalocean_droplet.web[count.index].ipv4_address]
}

locals {
  droplet_info = [templatefile("${path.module}/backends.tftpl", {
      dns_record_names = aws_route53_record.my_dns_record.*.fqdn
      ipv4_addresses = digitalocean_droplet.web.*.ipv4_address
      root_passwords = random_password.password.*.result
    })
  ]
}

resource "local_file" "droplets_info" {
  filename = "droplets_info.txt"
  content  = join("", local.droplet_info)
}
