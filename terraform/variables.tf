variable "do_token" {
  type        = string
  description = "digital ocean token"
  sensitive   = true
}
variable "do_ssh_key" {
  type        = string
  description = "digital ocean SSH key"
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
