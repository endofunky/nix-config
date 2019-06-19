{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
in
{
  home.packages = [
    pkgs.dropbox
  ];

  xsession = {
    enable = true;
    windowManager.command = "emacs";

    profileExtra = ''
      xset -b

      xset r rate 250 50

      xinput --set-prop "pointer:Logitech MX Master 2S" "libinput Accel Speed" 0.4
      xinput --set-prop "pointer:Logitech MX Master 2S" "libinput Natural Scrolling Enabled" 0
      test -r ${home_directory}/media/images/Paver.pm && hsetroot -tile ${home_directory}/media/images/Paver.pm

      autorandr -c
    '';
  };

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

  programs.autorandr = {
    enable = true;

    profiles = {
      "jnz" = {
        fingerprint = {
          eDP1 = "00ffffffffffff0006af3d2600000000001b0104951f117802a2b591575894281c505400000001010101010101010101010101010101843a8034713828403064310035ad1000001ad02e8034713828403064310035ad1000001a000000fe005638484b39804231343048414e0000000000008102a8001100000a010a2020006d";
        };
        config = {
          eDP1 = {
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
        };
      };
      "jnz-work" = {
        fingerprint = {
          eDP1 = "00ffffffffffff0006af3d2600000000001b0104951f117802a2b591575894281c505400000001010101010101010101010101010101843a8034713828403064310035ad1000001ad02e8034713828403064310035ad1000001a000000fe005638484b39804231343048414e0000000000008102a8001100000a010a2020006d";
          HDMI1 = "00ffffffffffff0010ace8404c323743341c010380351e78eaee95a3544c99260f5054a54b00714f8180a940d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00354b3959443843524337324c0a000000fc0044454c4c205532343137480a20000000fd00324b1e5311000a2020202020200150020326f14f90050403020716010611121513141f2309070765030c00100083010000e3050000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f2821000018000000000000000000000000000000000019";
        };
        config = {
          HDMI1 = {
            dpi = 100;
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
          eDP1 = {
            enable = false;
            primary = false;
            # mode = "1920x1080";
            # position = "0x0";
            # rate = "60.00";
          };
        };
      };
      "laptop" = {
        fingerprint = {
          eDP1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
        };
        config = {
          eDP1 = {
            enable = true;
            primary = true;
            dpi = 120;
            mode = "2560x1440";
            position = "0x0";
            rate = "60.00";
          };
        };
      };
    };
  };

  xresources.extraConfig = ''
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
