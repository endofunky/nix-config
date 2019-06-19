{ config, pkgs, ... }:

{
  xsession = {
    pointerCursor = {
      package = pkgs.gnome3.defaultIconTheme;
      name = "Adwaita";
      size = 32;
    };

    profileExtra = ''
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
}
