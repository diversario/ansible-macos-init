# Run
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/diversario/ansible-macos-init/master/run.sh)"
```

# Tasks
Defined in `roles/common/tasks/main.yaml`.

What happens:
* Install `brew`
* Install `ansible`
* Generate an SSH keypair if one doesn't exist
* Authorize the SSH key with Github
* Install `brew` packages defined by `brew_packages` variable
* Install `brew cask` apps defined by `brew_cask_packages` variable
* Clone and install dotfiles from `diversario/dotfiles`
* Apply macOS config from `diversario/dotfiles/configs/.osx`
* Install macOS App Store apps defined by `mas_installed_apps` variable

While script runs, it will configure the current user for passwordless `sudo`. The rule is created in `/etc/sudoers.d/ansible-passwordless-sudo` and is removed on script termination.

At the beginning, default shell will be set to `zsh`. This is because Oh-My-ZSH is installed later and it will attempt to change the shell to `zsh` if it's not yet changed, causing a prompt (and we don't want any prompts when automating).

# Config
Packages and apps are defined in `default.config.yaml`.

Env vars:

* `GITHUB_ACCESS_TOKEN`: set in advance to avoid a prompt
* `SKIP_HOMEBREW`: do not install `brew` and `brew cask` packages
* `SKIP_MAS`: do not install App Store apps
