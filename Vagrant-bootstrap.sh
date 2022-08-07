#! /usr/bin/env bash
set -euxo pipefail

export VM_USER=vagrant
export VM_USER_HOME=/home/${VM_USER}

### apt update, install necessary packages

echo apt-get update
echo apt-get upgrade -y
echo apt-get install vim curl wget zip git -y

### pip (system package)

echo apt-get install python3-pip python3-venv -y

### add a custom section to the motd

cat << EOF > /etc/update-motd.d/99-custom
#!/bin/bash

echo simple MOTD
# if [[ -f /vagrant/.somefile ]] && [[ -d /home/vagrant/.somedirectory ]]; then
#     echo "something"
# else
#     echo "something else"
# fi
EOF

chmod +x /etc/update-motd.d/99-custom

### final steps

export USER_RC_FILE=${VM_USER_HOME}/.bashrc
export SYSTEM_RC_FILE=/etc/bash.bashrc
export COMMENT="# custom steps"
export ADDITIONAL_PATH='export PATH=$PATH:/home/vagrant/.local/bin'
export ADDITIONAL_INSTRUCTIONS='cd /vagrant; echo; echo $PWD; echo; ls ; echo'

if ! grep -qFx "${COMMENT}" ${USER_RC_FILE}; then
  echo -e "\n${COMMENT}\n# ${ADDITIONAL_PATH}\n${ADDITIONAL_INSTRUCTIONS}" | tee -a ${USER_RC_FILE}
fi

if ! grep -qFx "${COMMENT}" ${SYSTEM_RC_FILE}; then
  echo -e "\n${COMMENT}\n${ADDITIONAL_PATH}" | tee -a ${SYSTEM_RC_FILE}
fi
