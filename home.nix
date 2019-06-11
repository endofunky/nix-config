{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
  emacsHEAD = import ./pkgs/emacs.nix;
  asdfVM = import ./pkgs/asdf.nix;
in
{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/git.nix
    ./modules/ssh.nix
    ./modules/zsh.nix
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    ./modules/x11.nix
  ];

  home.packages = with pkgs; [
    aria2
    asdfVM
    emacsHEAD
    fish
    fortune
    mplayer
    pythonPackages.editorconfig
    ripgrep
    screen
    shellcheck
    whois
    zsh-git-prompt
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    google-chrome
    hsetroot
    i3lock
    scrot
    spotify
    traceroute
    whois
  ];

  home.file = {
    ".asdfrc".source = ./dotfiles/asdfrc;
    ".config/user-dirs.dirs".source = ./dotfiles/user-dirs.dirs;
    ".gemrc".source = ./dotfiles/gemrc;
    ".pryrc".source = ./dotfiles/pryrc;
    ".rspec".source = ./dotfiles/rspec;
    "media/images/Paver.pm".source = ./dotfiles/Paver.pm;
  };

  home.keyboard = {
    layout = "gb";
    options = [
      "ctrl:nocaps"
      "terminate:ctrl_alt_bksp"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    stdlib = builtins.readFile ./dotfiles/direnvrc;
  };

  programs.gpg.enable = true;
  programs.home-manager.enable = true;
  programs.info.enable = true;

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome   = "${home_directory}/.local/share";
    cacheHome  = "${home_directory}/.cache";
  };
}
