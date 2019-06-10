{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  sharedPackages = import ./shared-packages.nix (pkgs);
in
{
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.keyboard = {
    layout = "gb";
    options = [
      "ctrl:nocaps"
      "terminate:ctrl_alt_bksp"
    ];
  };

  home.packages = with pkgs; sharedPackages ++ stdenv.lib.optional stdenv.isLinux [
    google-chrome
    hsetroot
    i3lock
    mplayer
    sbcl
    scrot
    spotify
    traceroute
    whois
  ];
}
