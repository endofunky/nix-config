{ config, pkgs, ... }:

with import <nixpkgs> {};

{
  programs.git = {
    enable = true;
    userName  = "Tobias Svensson";
    userEmail = "tob@tobiassvensson.co.uk";

    aliases = {
      br = "branch -v";
      co = "checkout";
      g = "grep";
      ll = "log --stat -C -1";
      st = "status";
      dh = "diff HEAD";
      dm = "diff master";
      delete-merged-branches = "!git co master && git branch --merged | grep -v '\\\\*' | xargs -n 1 git branch -d";

      squash = "!git reset master && git add -A . && git commit";
      undo = "reset --soft HEAD~1";
      unstage = "reset HEAD --";

      up = "!git fetch && git rebase --autostash FETCH_HEAD";
      wip = "!git add -A && git commit -m 'wip [ci skip]'";

      assume   = "update-index --assume-unchanged";
      unassume = "update-index --no-assume-unchanged";
      assumed  = "!git ls-files -v | grep ^h | cut -c 3-";
    };

    extraConfig = {
      core = {
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
        autostash = true;
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
        autostash = true;
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

      http = {
        sslVerify = false;
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
      "*_flymake.*"
      "flycheck_*.el"

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

      # Direnv / nix
      ".direnv/"
      ".envrc"
      ".mysql"
      ".nix"
      ".nix-gems"
      "default.nix"
    ];
  };

}
