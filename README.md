# droplet-automation

Create/destroy a droplet (a [Virtual Machine on Digital Ocean](https://docs.digitalocean.com/products/droplets/)) for testing or as a remote dev environment.

- [pre-work](#pre-work)
- [create the droplet](#create-the-droplet)
- [provision the droplet](#provision-the-droplet)
- [destroy the droplet](#destroy-the-droplet)
- [test the playbook locally using Vagrant](#test-the-playbook-locally-using-vagrant)
- [docs and other useful links](#docs-and-other-useful-links)

## pre-work

- install `terraform` (see the [documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
  ```shell
  sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
  ```
  ```shell
  wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
  ```
  ```shell
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list
  ```
  ```shell
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
  ```
  ```shell
  terraform init
  ```
  ```shell
  # (optional) show the execution plan
  # terraform plan -var "do_token=$(cat ../.credentials/do_token)" \
  #   -var-file="my-new-droplet.tfvars"
  ```
  ```shell
  terraform apply -var "do_token=$(cat ../.credentials/do_token)" \
    -var-file="my-new-droplet.tfvars"
  ```
- alternatively, use the Makefile
  - `make droplet-show-plan VARFILE=my-new-droplet.tfvars` to show the execution plan
  - `make droplet-create VARFILE=my-new-droplet.tfvars` to create the droplet
  - `make droplet-print-ip` to show the droplet IP address

## provision the droplet

The initial provisioning will be done by `terraform` using `ansible` in a `local-exec` block.

To run `ansible` again manually:
- make sure the correct SSH keys are configured or `ForwardAgent` is enabled
- test the connection with `ansible`
  ```shell
  cd ansible
  ```
  ```shell
  ANSIBLE_HOST_KEY_CHECKING=False ansible \
    -u root -i $(terraform -chdir="../terraform" output droplet_ip_address), \
    -m ping all
  ```
- run the playbook:
  ```shell
  cd ansible
  ```
  ```shell
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
    -u root -i $(terraform -chdir="../terraform" output droplet_ip_address), \
    main.yml
  ```
- alternatively, use the Makefile
  - `make ansible-test` to test the connection with `ansible`
  - `make ansible-run` to run the `ansible` playbook

(optional) add `--tags "pyenv"` to the previous step to run _only_ the tasks to install and configure `pyenv` and `pyenv-virtualenv`

## destroy the droplet

- cd to the `terraform` directory and run:
  ```shell
  cd terraform
  ```
  ```shell
  terraform destroy -var "do_token=$(cat ../.credentials/do_token)" \
    -var-file="my-new-droplet.tfvars"
  ```
- alternatively, use the Makefile
  - `make droplet-destroy VARFILE=my-new-droplet.tfvars` to destroy the droplet

<details>

<summary>(optional) test the playbook locally using Vagrant</summary>

## test the playbook locally using Vagrant

- cd to the `vagrant` directory and run `vagrant up` to create/power on the local VM
  ```shell
  cd vagrant
  ```
  ```shell
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
</details>

## docs and other useful links

- [Terraform registry - DigitalOcean Provider](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs)
- [Terraform documentation - Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Docker documentation - Install Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)
- [pyenv](https://github.com/pyenv/pyenv)
- [pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)
