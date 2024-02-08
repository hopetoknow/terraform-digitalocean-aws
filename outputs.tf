output "balancer_droplet_password" {
  value = random_password.balancer_password
  description = "The random password of balancer"
  sensitive = true
}

output "app_droplet_password" {
  value = random_password.app_password
  description = "The random password of app"
  sensitive = true
}
