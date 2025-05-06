data "digitalocean_ssh_key" "ssh_keys" {
  for_each = toset(var.do_ssh_keys)
  name     = each.value
}

resource "digitalocean_droplet" "droplet" {
  image      = var.droplet_image
  name       = "${var.droplet_name}-${var.droplet_size}-${var.droplet_region}"
  region     = var.droplet_region
  size       = var.droplet_size
  monitoring = true
  tags       = var.droplet_tags
  ssh_keys   = [for key in data.digitalocean_ssh_key.ssh_keys : key.id]

}
