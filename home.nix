{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
  emacsHEAD = import ./pkgs/emacs.nix;
  irssi-fish = import ./pkgs/irssi-fish.nix;
  sicp = import ./pkgs/sicp.nix;
  qodem = import ./pkgs/qodem.nix;
in
{
  nixpkgs.config = import ./dotfiles/config.nix;
  news.display = "silent";

  imports = [
    ./home/git.nix
    ./home/ssh.nix
    ./home/zsh.nix
    ./home/x11.nix
  ] ++ lib.optionals (builtins.pathExists ./private/home.nix) [
    ./private/home.nix
  ] ++ lib.optionals (builtins.pathExists ./home.local.nix) [
    ./home.local.nix
  ];

  home.packages = with pkgs; [
    aria2
    docker-compose
    emacsHEAD
    fish
    fortune
    google-chrome
    hsetroot
    i3lock
    irssi
    irssi-fish
    ispell
    mplayer
    mosh
    nix-prefetch-git
    openvpn
    python3Packages.editorconfig
    qodem
    ripgrep
    screen
    scrot
    shellcheck
    sicp
    spotify
    subversion
    unzip
    xmobar
    zoom-us
    zsh-git-prompt


    godef

    # Networking
    openconnect
    networkmanagerapplet
    traceroute
    whois

    # Kubernetes
    kubectl
    kubectx
    kubernetes-helm
    stern

    # Virtualization
    spice-vdagent
    virt-viewer
    virtmanager
  ];

  home.file = {
    ".gemrc".source = ./dotfiles/gemrc;
    ".irssi/startup".text = ''
      load ${irssi-fish}/lib/irssi/modules/libfish.so
    '';
    ".rspec".source = ./dotfiles/rspec;
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

  services.keybase.enable = true;

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome   = "${home_directory}/.local/share";
    cacheHome  = "${home_directory}/.cache";
    configFile = {
      "nixpkgs/config.nix".source = ./dotfiles/config.nix;
      "pry/pryrc".source = ./dotfiles/pryrc;
      "user-dirs.dirs".source = ./dotfiles/user-dirs.dirs;
      "xmobar/xmobarrc".source = ./dotfiles/xmobarrc;
    };
  };
}
