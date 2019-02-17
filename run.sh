#!/bin/bash

read -p "[IMPORTANT] Pre-requisites:

- Sign in into App Store to install apps
- Add Terminal.app to System Preferences -> Security & Privacy -> Full Disk Access to allow it to modify all defaults (this will restart Terminal)

Press any key to continue
"

read -p "Sign in into App Store and press any key to continue"

# get credentials for stuff right away
if [[ -z $SUDO_PASSWORD ]]; then
  read -s -p 'sudo password: ' SUDO_PASSWORD; echo ''
fi

if [[ -z $GITHUB_ACCESS_TOKEN ]]; then
  read -s -p 'Github access token: ' GITHUB_ACCESS_TOKEN; echo ''
fi

export SUDO_PASSWORD
export GITHUB_ACCESS_TOKEN

if [[ ! -f $(which brew) ]]; then
  CI=1 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install ansible
fi

WORKDIR=/tmp
ZIPBALL_URL="https://github.com/diversario/ansible-macos-init/archive/master.zip"
ZIPBALL_FILE=ansible-macos-init.zip

curl -fsSL $ZIPBALL_URL -o $WORKDIR/$ZIPBALL_FILE
cd $WORKDIR
unzip -o $ZIPBALL_FILE
cd ansible-macos-init-master

ansible-galaxy install -r requirements.yaml
ansible-playbook -i hosts.yaml setup-mac.yaml