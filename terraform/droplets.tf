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

resource "digitalocean_firewall" "dropletfw" {
  name = "droplet-allow-only-selected-ip"

  droplet_ids = [digitalocean_droplet.droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [for address in var.allowed_inbound_ip_addresses : address]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = [for address in var.allowed_inbound_ip_addresses : address]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = [for address in var.allowed_inbound_ip_addresses : address]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [for address in var.allowed_inbound_ip_addresses : address]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
