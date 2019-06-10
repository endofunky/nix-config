{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  emacsHEAD = import ./pkgs/emacs.nix;
  asdf = import ./pkgs/asdf.nix;
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

  home.packages = with pkgs; [
    aria2
    asdf
    emacsHEAD
    fish
    mplayer
    pythonPackages.editorconfig
    ripgrep
    screen
    whois
  ] ++ stdenv.lib.optional stdenv.isLinux [
    google-chrome
    hsetroot
    i3lock
    sbcl
    scrot
    spotify
    traceroute
    whois
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.gpg.enable = true;
  programs.info.enable = true;

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    enableAutosuggestions = false;

    defaultKeymap = "viins";

    history = {
      size = 50000;
      save = 500000;
      ignoreDups = true;
      share = true;
      extended = true;
    };

    sessionVariables = {
      CLICOLOR = "1";
      EDITOR = "vim";
      KEYTIMEOUT = "1";
      LC_CTYPE = "en_US.UTF-8";
      LSCOLORS = "Gxfxcxdxbxegedabagacad";
      TERM = "xterm-256color";
      VISUAL = "vim";
    };

    initExtra = ''
      autoload bashcompinit
      bashcompinit
      setopt nolist_beep

      if [ -f "$HOME/.nix-profile/share/bash-completion/completions/asdf.bash" ]; then
        . "$HOME/.nix-profile/share/bash-completion/completions/asdf.bash"
      fi

      if test -f $HOME/.zshrc.local; then
        source $HOME/.zshrc.local
      fi
    '';

    profileExtra = ''
      export RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.3
      export RUBY_HEAP_SLOTS_INCREMENT=1000000
      export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
      export RUBY_GC_MALLOC_LIMIT=1000000000
      export RUBY_HEAP_FREE_MIN=500000

      if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
      fi

      export PATH="$HOME/bin:$PATH"
      export PATH="$HOME/.asdf/shims:$PATH"

      export GOPATH=$HOME/projects/go
      export GOBIN=$HOME/projects/go/bin
      export PATH=$PATH:$GOBIN

      mkdir -p $GOBIN
      mkdir -p $HOME/projects/go/pkg
      mkdir -p $HOME/projects/go/src

      if [ -d /usr/local/opt/qt@5.5 ]; then
        export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
        export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
      fi

      if test -f $HOME/.zprofile.local; then
        source $HOME/.zprofile.local
      fi
    '';
  };
}
