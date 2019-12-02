{ config, pkgs, ... }:

with import <nixpkgs> {};

let
  home_directory = builtins.getEnv "HOME";
  background = ./../dotfiles/Paver.pm;
in
{
  xsession = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
      extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
        hpkgs.xmonad-spotify
      ];
      enableContribAndExtras = true;
      config = ../dotfiles/xmonad/xmonad.hs;
    };

    profileExtra = ''
      xinput_check() {
          local XINPUT_NAME
          XINPUT_NAME="$1"
          if [ ! -z "$XINPUT_NAME" ]; then
              xinput --list | grep -q "$XINPUT_NAME"
              return $?
          else
              return 1
          fi
      }

      if xinput_check "Logitech MX Master 2S"; then
        xinput --set-prop "Logitech MX Master 2S" "libinput Accel Speed" 0.4
        xinput --set-prop "Logitech MX Master 2S" "libinput Natural Scrolling Enabled" 0
      fi

      if xinput_check "MX Master 2S Mouse"; then
        xinput --set-prop "MX Master 2S Mouse" "libinput Accel Speed" 0.4
        xinput --set-prop "MX Master 2S Mouse" "libinput Natural Scrolling Enabled" 0
        xinput --set-prop "MX Master 2S Mouse" "libinput Accel Profile Enabled" 0, 1
      fi

      if xinput_check "SynPS/2 Synaptics TouchPad"; then
        xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 0.7
        xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
        xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
        xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Disable While Typing Enabled" 1
      fi

      if xinput_check "Synaptics TM3289-002"; then
        xinput --set-prop "Synaptics TM3289-002" "libinput Accel Speed" 0.7
        xinput --set-prop "Synaptics TM3289-002" "libinput Tapping Enabled" 1
        xinput --set-prop "Synaptics TM3289-002" "libinput Natural Scrolling Enabled" 1
        xinput --set-prop "Synaptics TM3289-002" "libinput Disable While Typing Enabled" 1
      fi

      hsetroot -tile ${background}

      xset -b

      xset r rate 250 50

      setxkbmap -option caps:ctrl_modifier

      autorandr -c
    '';
  };

  programs.autorandr = {
    enable = true;

    profiles = {
      "laptop-work" = {
        fingerprint = {
          eDP1 = "00ffffffffffff0030e48b0500000000001a0104a51f1178e25715a150469d290f505400000001010101010101010101010101010101695e00a0a0a029503020a50035ae1000001a000000000000000000000000000000000000000000fe004c4720446973706c61790a2020000000fe004c503134305148322d5350423100b8";
          HDMI1 = " 00ffffffffffff0030aec860010101012d1a010380351e782e2195a756529c26105054bdcf00714f8180818c9500b300d1c001010101023a801871382d40582c45000f282100001e000000ff0056314d38333335310a20202020000000fd00324b1e5311000a202020202020000000fc004c454e20543234323470410a20013f02031ef14b010203040514111213901f230907078301000065030c001000011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f28210000188c0ad090204031200c4055000f282100001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000ce";
        };
        config = {
          HDMI1 = {
            dpi = 80;
            enable = true;
            primary = true;
            mode = "1920x1080";
            position = "0x0";
            rate = "60.00";
          };
          eDP1 = {
            enable = false;
            primary = false;
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
    ! DOS-box colours...
    *foreground: rgb:a8/a8/a8
    *background: rgb:00/00/00
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

    XTerm*dynamicColors: true
    XTerm*eightBitInput: false
    xterm*faceName: DejaVu Sans Mono Book
    xterm*faceSize: 11
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
  '';
}
