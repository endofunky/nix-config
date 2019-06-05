{ config, pkgs, ... }:

let
  emacsHEAD = import ./pkgs/emacs.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    emacsHEAD
    pkgs.aria2
    pkgs.curl
    pkgs.git
    pkgs.gnupg
    pkgs.pythonPackages.editorconfig
    pkgs.ripgrep
    pkgs.screen
    pkgs.vim
    pkgs.whois
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 20;
    KeyRepeat = 1;
  };

  system.defaults.dock = {
    autohide = true;
    showhidden = true;
    mru-spaces = false;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    QuitMenuItem = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.maxJobs = 1;
  nix.buildCores = 1;
}
