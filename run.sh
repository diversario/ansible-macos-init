#!/bin/bash

WORKDIR=/tmp
ZIPBALL_URL="https://github.com/diversario/ansible-macos-init/archive/master.zip"
ZIPBALL_FILE=ansible-macos-init.zip

if [[ ! -f $(which brew) ]]; then
  CI=1 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install ansible
fi

curl -fsSL $ZIPBALL_URL -o $WORKDIR/$ZIPBALL_FILE
cd $WORKDIR
unzip -o $ZIPBALL_FILE
cd ansible-macos-init-master

ansible-galaxy install -r requirements.yaml
ansible-playbook -i hosts.yaml setup-mac.yaml