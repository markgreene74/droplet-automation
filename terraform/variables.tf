variable "do_token" {
  type        = string
  description = "digital ocean token"
  sensitive   = true
}
variable "do_ssh_keys" {
  type        = list(string)
  description = "digital ocean SSH keys (i.e., ['ssh-key-1', 'ssh-key-2'])"
}
variable "droplet_image" {
  type        = string
  description = "droplet base image (i.e., debian-12-x64)"
}
variable "droplet_name" {
  type        = string
  description = "droplet base name (i.e., new-project)"
}
variable "droplet_region" {
  type        = string
  description = "droplet region (i.e., lon1)"
}
variable "droplet_size" {
  type        = string
  description = "droplet size (i.e., s-2vcpu-4gb)"
}
variable "droplet_tags" {
  type        = list(string)
  description = "droplet tags (i.e., ['python', 'my-new-project'])"
}
variable "allowed_inbound_ip_addresses" {
  type        = list(string)
  description = "list of IPs addresses to be allowed in the inbound section in the firewall (i.e., ['192.168.1.10/32', '192.168.1.0/24'])"
}
