#!/bin/bash

WORKDIR=/tmp
ZIPBALL_URL="https://github.com/diversario/ansible-macos-init/archive/master.zip"
ZIPBALL_FILE=ansible-macos-init.zip

echo 'Enter credentials for installation'

read -s -p 'sudo password: ' SUDO_PASSWORD; echo ''
read -s -p 'Github access token: ' GITHUB_ACCESS_TOKEN; echo ''
read -p 'Apple ID email: ' MAS_EMAIL
read -s -p 'Apple ID password: ' MAS_PASSWORD; echo ''

export SUDO_PASSWORD
export GITHUB_ACCESS_TOKEN
export MAS_EMAIL
export MAS_PASSWORD

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