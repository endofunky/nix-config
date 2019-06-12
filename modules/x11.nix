{ config, pkgs, ... }:

with import <nixpkgs> {};

{
  xsession = {
    enable = true;
    windowManager.command = "emacs";

    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 32;
    };

    profileExtra = ''
      xset -b

      xinput --set-prop "pointer:Logitech MX Master 2S" "libinput Accel Speed" 0.4
      xinput --set-prop "pointer:Logitech MX Master 2S" "libinput Natural Scrolling Enabled" 0
      xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 0.7
      xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
      xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1
      xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Disable While Typing Enabled" 1
      xinput --set-prop "Synaptics TM3289-002" "libinput Accel Speed" 0.7
      xinput --set-prop "Synaptics TM3289-002" "libinput Tapping Enabled" 1
      xinput --set-prop "Synaptics TM3289-002" "libinput Natural Scrolling Enabled" 1
      xinput --set-prop "Synaptics TM3289-002" "libinput Disable While Typing Enabled" 1
    '';
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
