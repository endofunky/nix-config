{ config, pkgs, ... }:

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

  home.packages = sharedPackages ++ [
    pkgs.google-chrome
    pkgs.hsetroot
    pkgs.i3lock
    pkgs.mplayer
    pkgs.sbcl
    pkgs.scrot
    pkgs.spotify
    pkgs.traceroute
    pkgs.whois
  ];
}
