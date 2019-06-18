#!/usr/bin/env bash

echo "Linking NixOS configuration ..."
sudo ln -sf $PWD/configuration.nix /etc/nixos/configuration.nix
sudo ln -sf /etc/nixos/hardware-configuration.nix $PWD/hardware-configuration.nix 

# echo "Bootstrapping home-manager config ..."
# ln -sf $PWD/config.nix $HOME/.config/nixpkgs/config.nix
# nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
# nix-channel --update
# nix-shell '<home-manager>' -A install
# mkdir -p $HOME/.config/nixpkgs
# ln -sf $PWD/home.nix $HOME/.config/nixpkgs/home.nix
