output "balancer_droplet_passwords" {
  value = random_password.balancer_password
  description = "The random password of droplet"
  sensitive = true
}

output "app_droplet_passwords" {
  value = random_password.app_password
  description = "The random password of droplet"
  sensitive = true
}
