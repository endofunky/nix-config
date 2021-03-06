{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
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

    shellAliases = {
      bake = "bundle exec rake";
      be = "bundle exec";
      cdg = "git rev-parse --show-toplevel && cd $(git rev-parse --show-toplevel)";
      k = "kubectl";
      kc = "kubectx";
      kn = "kubens";
      ls = "ls --color";
      pgstart = "pg_ctl start -o '-c listen_addresses= -c unix_socket_directories=$PGHOST'";
      pgstop = "pg_ctl stop -D $PGDATA";
      ocd = "sudo pkill -SIGINT openconnect && nmcli con down tun0";
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

      source ${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh

      PROMPT='%1~%b$(git_super_status) %# '

      if test -f ${home_directory}/.zshrc.local; then
        source ${home_directory}/.zshrc.local
      fi

      function kexec() {
        pod="$(k get pods | grep "$1" | head -n 1 | awk '{ print $1 }')"

        if [ -z "$pod" ]; then
          echo "No pod matching pattern $1 found" 1>&2;
          return "-1"
        fi

        echo "Using $pod on $(kubectl config current-context)" 1>&2;

        if [ -z "$2" ]; then
          kubectl exec -it $pod bash
        else
          kubectl exec -it $pod $2
        fi
      }

      [[ -x $(which fortune) ]] && fortune && printf "\n"
    '';

    profileExtra = ''
      export RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.3
      export RUBY_HEAP_SLOTS_INCREMENT=1000000
      export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
      export RUBY_GC_MALLOC_LIMIT=1000000000
      export RUBY_HEAP_FREE_MIN=500000

      export PATH="${home_directory}/bin:$PATH"
      export PATH=".git/safe/../../bin:$PATH"

      export GOPATH=${home_directory}/projects/go
      export GOBIN=${home_directory}/projects/go/bin
      export PATH=$GOBIN:$PATH

      mkdir -p $GOBIN
      mkdir -p ${home_directory}/projects/go/pkg
      mkdir -p ${home_directory}/projects/go/src

      if test -f ${home_directory}/.zprofile.local; then
        source ${home_directory}/.zprofile.local
      fi
    '';

    logoutExtra = "[[ -o INTERACTIVE && -t 2 ]] && clear >&2";
  };

}
