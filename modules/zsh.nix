{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
  asdfVM = import ../pkgs/asdf.nix;
in
{
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
      DIRENV_LOG_FORMAT = "";
      EDITOR = "vim";
      KEYTIMEOUT = "1";
      LC_CTYPE = "en_US.UTF-8";
      LSCOLORS = "Gxfxcxdxbxegedabagacad";
      TERM = "xterm-256color";
      VISUAL = "vim";
    };

    initExtra = ''
      autoload -Uz compinit && compinit -d "${home_directory}/.zsh/zcompdump"
      autoload bashcompinit && bashcompinit
      setopt nolist_beep

      bindkey '^R' history-incremental-search-backward
      bindkey -M vicmd '/' history-incremental-search-backward
      bindkey -M isearch '^P' history-incremental-search-backward
      bindkey -M isearch '^N' history-incremental-search-forward
      bindkey '^P' up-history
      bindkey '^N' down-history
      bindkey '^?' backward-delete-char
      bindkey '^W' backward-kill-word
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd e edit-command-line

      zstyle ":completion:*" menu select=1
      zstyle ":completion:*" use-cache on
      zstyle ":completion:*" group-name ""
      zstyle ":completion:*" cache-path "${home_directory}/.zsh/zcompcache"
      zstyle ":completion:*" completer _expand _complete _ignored _approximate

      autoload -U colors
      colors

      source ${asdfVM}/share/asdf/completions/asdf.bash
      source ${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh

      PROMPT='%1~%b$(git_super_status) %# '

      if test -f ${home_directory}/.zshrc.local; then
      source ${home_directory}/.zshrc.local
      fi
    '';

    profileExtra = ''
      export RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.3
      export RUBY_HEAP_SLOTS_INCREMENT=1000000
      export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
      export RUBY_GC_MALLOC_LIMIT=1000000000
      export RUBY_HEAP_FREE_MIN=500000

      export PATH="${home_directory}/bin:$PATH"

      export GOPATH=${home_directory}/projects/go
      export GOBIN=${home_directory}/projects/go/bin
      export PATH=$GOBIN:$PATH

      mkdir -p $GOBIN
      mkdir -p ${home_directory}/projects/go/pkg
      mkdir -p ${home_directory}/projects/go/src

      if test -f ${home_directory}/.zprofile.local; then
      source ${home_directory}/.zprofile.local
      fi

      source ${asdfVM}/share/asdf/asdf.sh
    '';

    logoutExtra = "[[ -o INTERACTIVE && -t 2 ]] && clear >&2";
  };

}
