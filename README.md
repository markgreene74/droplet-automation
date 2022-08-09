# droplet-automation

Create/destroy a droplet (a [Virtual Machine on Digital Ocean](https://docs.digitalocean.com/products/droplets/)) for testing.

## pre-work

- install `terraform` (see [here](https://www.terraform.io/downloads))
  ```shell
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt-get update && sudo apt-get install terraform -y
  ```

- install `ansible`
  ```shell
  apt-get update && apt-get install ansible -y
  ```

- make sure the file containing the Digital Ocean token (`do_token`) is present in the `.credentials` directory
- make sure the JSON files containing the configuration for additional users are present in the `.credentials` directory
- make sure the `.tfvars` file (for example, `whistab.tfvars`) is present and contains the path to private/public keys
- (optional) install Vagrant and VirtualBox to test the playbook on a local Virtual Machine (VM)

## create the droplet

- cd to the `terraform` directory and run:
  ```shell
  cd terraform
  terraform init
  # (optional) terraform plan -var "do_token=$(cat ../.credentials/do_token)" -var-file="whistab.tfvars"
  terraform apply -var "do_token=$(cat ../.credentials/do_token)" -var-file="whistab.tfvars"
  ```

## provision the droplet

The initial provisioning will be done by `terraform`.

If you wish to run the provisioning again manually:

- make sure the env variables `PRIVATE_KEY` and `PUBLIC_KEY` are set correctly
  ```shell
  export PRIVATE_KEY=<full path to your private key>
  export PUBLIC_KEY=<full path to your public key>
  ```

- run the Ansible playbook:
  ```shell
  cd ansible
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
    -u root -i '$(../terraform/terraform show droplet_ip_address),' \
    --private-key ${PRIVATE_KEY} \
    -e 'pub_key=${PUBLIC_KEY}' \
    main.yml
  ```

- (optional) add `--tags "pyenv"` to the previous step to run _only_ the tasks to install and configure `pyenv` and `pyenv-virtualenv`

## destroy the droplet

- cd to the `terraform` directory and run:

  ```shell
  cd terraform
  terraform destroy -var "do_token=$(cat ../.credentials/do_token)" -var-file="whistab.tfvars"
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
