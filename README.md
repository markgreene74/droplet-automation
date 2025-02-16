# droplet-automation

Create/destroy a droplet (a [Virtual Machine on Digital Ocean](https://docs.digitalocean.com/products/droplets/)) for testing or as a remote dev environment.

## pre-work

- install `terraform` (see the [documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
  ```shell
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install terraform -y
  ```
- install `ansible`
  ```shell
  sudo apt-get update && sudo apt-get install ansible -y
  ```
- make sure the file containing the DigitalOcean token (`do_token`) is present in the `.credentials` directory
- (optional) if running `terraform`+`ansible` from a local VM make sure that `ForwardAgent` is enabled (`ForwardAgent yes` in the `.ssh/config` file)
- make sure the `.tfvars` file (for example, `my-new-droplet.tfvars`) is populated, look at the `example.tfvars` file
- (optional) install Vagrant and VirtualBox to test the playbook on a local Virtual Machine (VM)

## create the droplet

- cd to the `terraform` directory and run:
  ```shell
  cd terraform
  terraform init
  # (optional) show the execution plan
  # terraform plan -var "do_token=$(cat ../.credentials/do_token)" \
  #   -var-file="my-new-droplet.tfvars"
  terraform apply -var "do_token=$(cat ../.credentials/do_token)" \
    -var-file="my-new-droplet.tfvars"
  ```

## provision the droplet

The initial provisioning will be done by `terraform` using `ansible` in a `local-exec` block.

To run `ansible` again manually:
- make sure the correct SSH keys are configured or `ForwardAgent` is enabled
- test the connection with `ansible`
  ```shell
  ANSIBLE_HOST_KEY_CHECKING=False ansible \
    -u root -i $(terraform -chdir="../terraform" output droplet_ip_address), \
    -m ping all
  ```
- run the playbook:
  ```shell
  cd ansible
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
    -u root -i $(terraform -chdir="../terraform" output droplet_ip_address), \
    main.yml
  ```
- (optional) add `--tags "pyenv"` to the previous step to run _only_ the tasks to install and configure `pyenv` and `pyenv-virtualenv`

## destroy the droplet

- cd to the `terraform` directory and run:
  ```shell
  cd terraform
  terraform destroy -var "do_token=$(cat ../.credentials/do_token)" \
    -var-file="my-new-droplet.tfvars"
  ```

## test the playbook locally using Vagrant

- cd to the `vagrant` directory and run `vagrant up` to create/power on the local VM
  ```shell
  cd vagrant
  vagrant up
  ```
- test the connection to the VM:
  ```shell
  ANSIBLE_HOST_KEY_CHECKING=False ansible -u vagrant \
    --private-key .vagrant/machines/ansible-test/virtualbox/private_key \
    -i '127.0.0.1:2222,' all \
    -m ping
  ```
- run the ansible playbook on the VM:
  ```shell
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u vagrant \
    --private-key .vagrant/machines/ansible-test/virtualbox/private_key \
    -i '127.0.0.1:2222,' \
    ../ansible/main.yml
  ```

## docs and other useful links

- [Terraform registry - DigitalOcean Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
- [Terraform documentation - Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Docker documentation - Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)
- [pyenv](https://github.com/pyenv/pyenv)
- [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
