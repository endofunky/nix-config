#!/usr/bin/env bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
  ./result/bin/darwin-installer
  ln -sf $PWD/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix
  . /etc/static/bashrc
  darwin-rebuild switch
fi
