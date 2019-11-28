{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.dropbox
  ];

  systemd.user.services.dropbox = {
    Unit = {
      Description = "Dropbox";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.dropbox}/bin/dropbox";
    };
  };

  xsession = {
    pointerCursor = {
      package = pkgs.gnome3.defaultIconTheme;
      name = "Adwaita";
      size = 32;
    };
  };
}
