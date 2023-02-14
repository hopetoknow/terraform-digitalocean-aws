output "droplet_passwords" {
	value = random_password.password
	description = "The random password of droplet"
	sensitive = true
}