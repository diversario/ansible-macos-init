#!/bin/bash

read -p "[IMPORTANT] Pre-requisites:

- Sign in into App Store to install apps
- Add Terminal.app to System Preferences -> Security & Privacy -> Full Disk Access to allow it to modify all defaults (this will restart Terminal)

Press any key to continue
"

TEMP_SUDOERS_FILE=/etc/sudoers.d/ansible-passwordless-sudo

function cleanup() {
  sudo rm $TEMP_SUDOERS_FILE
}

trap cleanup SIGINT SIGTERM ERR EXIT

echo "Passwordless sudo will be enabled for the duration of the install"
echo '%admin ALL = (ALL) NOPASSWD: ALL' | sudo tee $TEMP_SUDOERS_FILE

# If this user's login shell is not already "zsh", attempt to switch.
echo "Switching shell to zsh now to avoid a password prompt later"
TEST_CURRENT_SHELL=$(basename "$SHELL")
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
  chsh -s $(grep /zsh$ /etc/shells | tail -1) || true
fi

if [[ -z $GITHUB_ACCESS_TOKEN ]]; then
  read -s -p 'Github access token: ' GITHUB_ACCESS_TOKEN; echo ''
fi

# export SUDO_PASSWORD
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

if [[ -z SKIP_MAS ]]; then
  ansible-playbook -i hosts.yaml setup-mac.yaml
else
  ansible-playbook -i hosts.yaml setup-mac.yaml --extra-vars '{"mas_installed_apps":[]}'
fi