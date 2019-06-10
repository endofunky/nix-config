{ pkgs, ... }:

let
  emacsHEAD = import ./pkgs/emacs.nix;
  asdf = import ./pkgs/asdf.nix;
in
with pkgs; [
  emacsHEAD
  asdf
  aria2
  fish
  gnupg
  pythonPackages.editorconfig
  ripgrep
  screen
  whois
]
