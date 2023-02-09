resource "digitalocean_ssh_key" "my_ssh_key" {
  name       = var.email_tag
  public_key = file(var.digitalocean_ssh_key_file_path)
}

resource "digitalocean_droplet" "web" {
  count = var.droplet_count
  image  = "ubuntu-22-04-x64"
  name   = "web-${count.index + 1}"
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size   = element(data.digitalocean_sizes.main.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.some_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = ["devops", var.email_tag]
}

# locals {
#   droplet_ips = [for droplet in digitalocean_droplet.web : droplet.ipv4_address]
# }

resource "aws_route53_record" "my_dns_record" {
  count = var.droplet_count
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${var.personal_domain_prefix}-${count.index + 1}.${data.aws_route53_zone.primary.name}"
  type    = "A"
  ttl     = "300"
  # records = local.droplet_ips
  records = [digitalocean_droplet.web[count.index].ipv4_address]
}
