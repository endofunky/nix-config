{ pkgs, ... }:

let
  emacsHEAD = import ./pkgs/emacs.nix;
  asdf = import ./pkgs/asdf.nix;
in
[
  emacsHEAD
  asdf
  pkgs.aria2
  pkgs.curl
  pkgs.fish
  pkgs.git
  pkgs.gnupg
  pkgs.pythonPackages.editorconfig
  pkgs.ripgrep
  pkgs.screen
  pkgs.vim
  pkgs.whois
]
