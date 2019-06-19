{ config, pkgs, ... }:

{
  xsession = {
    pointerCursor = {
      package = pkgs.gnome3.defaultIconTheme;
      name = "Adwaita";
      size = 16;
    };

    profileExtra = ''
      xinput --set-prop "DELL0816:00 044E:121F Touchpad" "libinput Accel Speed" 0.7
      xinput --set-prop "DELL0816:00 044E:121F Touchpad" "libinput Tapping Enabled" 1
      xinput --set-prop "DELL0816:00 044E:121F Touchpad" "libinput Natural Scrolling Enabled" 1
      xinput --set-prop "DELL0816:00 044E:121F Touchpad" "libinput Disable While Typing Enabled" 1
    '';
  };
}
