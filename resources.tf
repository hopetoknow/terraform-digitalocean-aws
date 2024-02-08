resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = var.email_tag
  public_key = file(var.public_ssh_key_file_path)
}

resource "random_password" "balancer_password" {
  length = var.password_parameters.length
  special = var.password_parameters.special
}

resource "digitalocean_droplet" "balancer" {
  image  = var.balancer_droplet_parameters.image
  name   = var.balancer_droplet_parameters.name
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size   = element(data.digitalocean_sizes.balancer.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.existing_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = [var.team_tag, var.email_tag]

  provisioner "remote-exec" {
    connection {
      type     = var.droplets_connection.type
      user     = var.droplets_connection.user
      private_key = file(var.private_ssh_key_file_path)
      host     = self.ipv4_address
      agent    = var.droplets_connection.agent
    }

    inline = [
      "echo \"${var.droplets_connection.user}:${random_password.balancer_password.result}\" | sudo chpasswd"
    ]
  }
}

resource "random_password" "app_password" {
  count = var.app_droplet_parameters.count
  length = var.password_parameters.length
  special = var.password_parameters.special
}

resource "digitalocean_droplet" "app" {
  count = var.app_droplet_parameters.count
  image  = var.app_droplet_parameters.image
  name   = "${var.app_droplet_parameters.name}-${count.index + 1}"
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size   = element(data.digitalocean_sizes.app.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.existing_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = [var.team_tag, var.email_tag]

  provisioner "remote-exec" {
    connection {
      type     = var.droplets_connection.type
      user     = var.droplets_connection.user
      private_key = file(var.private_ssh_key_file_path)
      host     = self.ipv4_address
      agent    = var.droplets_connection.agent
    }

    inline = [
      "echo \"${var.droplets_connection.user}:${random_password.app_password[count.index].result}\" | sudo chpasswd"
    ]
  }
}

resource "aws_route53_record" "my_dns_record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name = var.aws_parameters.record_name
  type    = var.aws_parameters.record_type
  ttl     = var.aws_parameters.record_ttl
  records = [digitalocean_droplet.balancer.ipv4_address]
}

locals {
  droplet_info = [templatefile("${path.module}/inventory_template.tftpl", {
      fqdn = aws_route53_record.my_dns_record.fqdn
      lb_ip = digitalocean_droplet.balancer.ipv4_address
      app_ips = digitalocean_droplet.app[*].ipv4_address
    })
  ]
}

resource "local_file" "ansible_inventory" {
  filename = "ansible/ansible_inventory"
  content  = join("", local.droplet_info)
}

resource "null_resource" "ansible_execution" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible_inventory playbook.yml --private-key=${var.private_ssh_key_file_path}" 
    working_dir = "${path.module}/ansible" 
  }
}
