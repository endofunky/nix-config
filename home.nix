{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
  emacsHEAD = import ./pkgs/emacs.nix;
  asdfVM = import ./pkgs/asdf.nix;
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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    stdlib = builtins.readFile ./dotfiles/direnvrc;
  };

  programs.gpg.enable = true;
  programs.info.enable = true;

  programs.git = {
    enable = true;
    userName  = "Tobias Svensson";
    userEmail = "tob@tobiassvensson.co.uk";

    aliases = {
      br = "branch -v";
      co = "checkout";
      find = "!git grep --break -C1";
      g = "grep";
      ll = "log --stat -C -1";
      st = "status";
      delete-merged-branches = "!git co master && git branch --merged | grep -v '\\\\*' | xargs -n 1 git branch -d";

      d = "diff";
      dh = "!git diff HEAD .";
      dm = "diff master";

      squash = "!git reset master && git add -A . && git commit";
      undo = "reset --soft HEAD~1";
      unstage = "reset HEAD --";

      up = "!git fetch && git rebase --autostash FETCH_HEAD";
      wip = "!git add -A && git commit -m 'wip [ci skip]'";

      rb = "rebase";
      rbc = "rebase --continue";
      rbm = "!git rebase master";
      rbmi = "!git rebase -i master";
      rbs = "rebase --skip";

      assume   = "update-index --assume-unchanged";
      unassume = "update-index --no-assume-unchanged";
      assumed  = "!git ls-files -v | grep ^h | cut -c 3-";
    };

    extraConfig = {
      core = {
        excludesfile = "~/.gitignore";
        autocrlf = "input";
        quotepath = "false";
        pager = "`test \"$TERM\" = \"dumb\" && echo cat || echo less`";
      };

      color = {
        ui = "true";
      };

      "color \"branch\"" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };

      "color \"diff\"" = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };

      "color \"status\"" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };

      apply = {
        whitespace = "warn";
      };

      push = {
        default = "current";
      };

      pull = {
        rebase = true;
      };

      merge = {
        ff = "only";
      };

      fetch = {
        prunte = true;
      };

      rebase = {
        autosquash = true;
      };

      log = {
        date = "relative";
      };

      remote = {
        pushDefault = "origin";
      };

      diff = {
        algorithm = "patience";
      };
    };

    ignores = [
      # OS X
      ".DS_Store"
      ".Spotlight-V100"
      ".Trashes"
      "._*"

      # Windows
      "Desktop.ini"
      "Thumbs.db"

      # Python
      "*.py[co]"

      # Vim
      "[._]*.s[a-w][a-z]"
      "[._]s[a-w][a-z]"
      "*.un~"
      "Session.vim"
      ".netrwhist"
      "*~"

      # Rubinius
      "*.rbc"

      # Bundler
      ".bundle"

      # Emacs
      "\#*#"
      ".\#*"
      "*.elc"
      ".dir-locals.el"
      ".projectile"

      # ycmd
      ".ycm_extra_conf.py"

      # Sass
      ".sass-cache"

      # solargraph
      ".solargraph.yml"

      # Tags
      "TAGS"
      "!TAGS/"
      "tags"
      "!tags/"
      ".tags"
      ".tags1"
      "gtags.files"
      "GTAGS"
      "GRTAGS"
      "GPATH"
      "cscope.files"
      "cscope.out"
      "cscope.in.out"
      "cscope.po.out"
      "compile_commands.json"
      ".ccls-cache"
    ];
  };

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
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome   = "${home_directory}/.local/share";
    cacheHome  = "${home_directory}/.cache";
  };

  xsession = if !stdenv.isLinux then {} else {
    enable = true;
    windowManager.command = "emacs";

    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 32;
    };
  };

  xresources.extraConfig = if !stdenv.isLinux then "" else ''
    XTerm*dynamicColors: true
    XTerm*eightBitInput: false
    xterm*faceName: DejaVu Sans Mono Book
    xterm*faceSize: 9
    XTerm*jumpScroll: true
    XTerm*loginShell: true
    XTerm*multiScroll: true
    XTerm*rightScrollBar: false
    XTerm*saveLines: 15000
    XTerm*scrollBar: false
    XTerm*scrollKey:true
    XTerm*scrollTtyKeypress: true
    XTerm*scrollTtyOutput: false
    XTerm*selectToClipboard: true
    XTerm*termName: XTerm-256color
    XTerm*toolBar: false
    XTerm*utf8: 2

    Xft*antialias:  true
    Xft*hinting:    true
    Xft*rgba:       rgb
    Xft*autohint:   false
    Xft*hintstyle:  hintslight
    Xft*lcdfilter:  lcddefault

    *foreground: white
    *background: black
    *color0: rgb:00/00/00
    *color1: rgb:a8/00/00
    *color2: rgb:00/a8/00
    *color3: rgb:a8/54/00
    *color4: rgb:00/00/a8
    *color5: rgb:a8/00/a8
    *color6: rgb:00/a8/a8
    *color7: rgb:a8/a8/a8
    *color8: rgb:54/54/54
    *color9: rgb:fc/54/54
    *color10: rgb:54/fc/54
    *color11: rgb:fc/fc/54
    *color12: rgb:54/54/fc
    *color13: rgb:fc/54/fc
    *color14: rgb:54/fc/fc
    *color15: rgb:fc/fc/fc
  '';
}
