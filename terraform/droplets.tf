data "digitalocean_ssh_key" "ssh_key" {
  name = var.do_ssh_key
}

resource "digitalocean_droplet" "droplet" {
  image      = var.droplet_image
  name       = "${var.droplet_name}-${var.droplet_size}-${var.droplet_region}"
  region     = var.droplet_region
  size       = var.droplet_size
  monitoring = true
  tags       = var.droplet_tags
  ssh_keys = [
    data.digitalocean_ssh_key.ssh_key.id
  ]

}
