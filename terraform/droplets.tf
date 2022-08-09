data "digitalocean_ssh_key" "ssh_key" {
  name = "thinkpad"
}

resource "digitalocean_droplet" "whistab_main" {
  image      = "debian-11-x64"
  name       = "debian-s-2vcpu-4gb-lon1-01"
  region     = "lon1"
  size       = "s-2vcpu-4gb"
  monitoring = true
  tags       = ["python", "whistab"]
  ssh_keys = [
    data.digitalocean_ssh_key.ssh_key.id
  ]

  provisioner "remote-exec" {
    inline = ["sudo apt-get update", "sudo apt-get install vim python3 -y", "sleep 30", "echo Done!"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
      timeout     = "2m"
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' ../ansible/main.yml"
  }

}
