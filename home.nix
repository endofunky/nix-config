{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
  asdfVM = import ./pkgs/asdf.nix;
  emacsHEAD = import ./pkgs/emacs.nix;
  sicp = import ./pkgs/sicp.nix;
in
{
  nixpkgs.config.allowUnfree = true;
  news.display = "silent";

  imports = [
    ./home/git.nix
    ./home/ssh.nix
    ./home/zsh.nix
    ./home/x11.nix
  ] ++ lib.optionals (builtins.pathExists ./home.local.nix) [
    ./home.local.nix
  ];

  home.packages = with pkgs; [
    aria2
    asdfVM
    emacsHEAD
    fish
    fortune
    google-chrome
    hsetroot
    i3lock
    ispell
    mplayer
    pythonPackages.editorconfig
    ripgrep
    screen
    scrot
    shellcheck
    sicp
    spotify
    traceroute
    unzip
    whois
    xmobar
    zoom-us
    zsh-git-prompt
  ];

  home.file = {
    ".asdfrc".source = ./dotfiles/asdfrc;
    ".config/pry/pryrc".source = ./dotfiles/pryrc;
    ".config/user-dirs.dirs".source = ./dotfiles/user-dirs.dirs;
    ".config/xmobar/xmobarrc".source = ./dotfiles/xmobarrc;
    ".gemrc".source = ./dotfiles/gemrc;
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

  home.sessionVariables = {
    BROWSER = "google-chrome-stable";
    CLICOLOR = "1";
    DIRENV_LOG_FORMAT = "";
    EDITOR = "vim";
    KEYTIMEOUT = "1";
    LC_ALL = "en_GB.UTF-8";
    LANGUAGE = "en_GB.UTF-8";
    LSCOLORS = "Gxfxcxdxbxegedabagacad";
    TERM = "xterm-256color";
    VISUAL = "vim";
  };

  gtk.enable = true;
  lib.enable = true;

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
