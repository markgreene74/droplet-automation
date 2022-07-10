# droplet-automation


## pre-work

- install `ansible`
  ```shell
  apt-get update && apt-get install ansible
  ```

- clone this repo
  ```shell
  git clone https://github.com/markgreene74/droplet-automation.git
  ```

- make sure the user is in the `sudo` group
  ```shell
  adduser ${USERNAME} sudo
  ```

## run ansible

- run the Ansible playbook, enter the user password when requested.
  ```shell
  ansible-playbook main.yml --ask-become-pass
  ```
