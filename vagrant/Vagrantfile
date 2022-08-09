vm_name = "ansible-test"

Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox
  config.vm.box = "debian/bullseye64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
    v.name = vm_name
  end

  config.vm.disk :disk, size: "10GB", primary: true
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.hostname = vm_name
  config.vm.define vm_name

  config.vm.post_up_message = "Debian 11 (bullseye)"

  config.vm.provision "base", type: "shell", path: "Vagrant-bootstrap.sh"
  config.vm.provision "custom", type: "shell", inline: "echo placeholder"

end
