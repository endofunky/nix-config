#!/usr/bin/env bash

if [ ! -d "/nix" ]; then
  curl https://nixos.org/nix/install | sh
  . $HOME/.nix-profile/etc/profile.d/nix.sh
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Bootstrapping nix-darwin ..."
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  ln -sf $PWD/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix
  . /etc/static/bashrc
  darwin-rebuild switch
elif [[ "$OSTYPE" == "linux-gnu" ]]; then
  sudo ln -sf $PWD/configuration.nix /etc/nixos/configuration.nix
  sudo ln -sf /etc/nixos/hardware-configuration.nix $PWD/hardware-configuration.nix
  sudo chown root.root /etc/nixos/configuration.nix
  sudo chmod 0644 /etc/nixos/configuration.nix
fi

echo "Bootstrapping home-manager config ..."
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
ln -sf $PWD/home.nix $HOME/.config/nixpkgs/home.nix
