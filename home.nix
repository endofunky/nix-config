{ config, pkgs, ... }:

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

  home.packages = with pkgs; [
    pkgs.aria2
    pkgs.gnupg
    pkgs.google-chrome
    pkgs.hsetroot
    pkgs.i3lock
    pkgs.mplayer
    pkgs.ripgrep
    pkgs.sbcl
    pkgs.screen
    pkgs.scrot
    pkgs.spotify
    pkgs.traceroute
    pkgs.whois
  ];
}
