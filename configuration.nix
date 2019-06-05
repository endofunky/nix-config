{ config, pkgs, ... }:

let
  emacsHEAD = import ./pkgs/emacs.nix;
in
{
  imports = [ ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.earlyVconsoleSetup = true;

  boot.initrd.luks.devices = [
    { name = "root"; device = "/dev/nvme0n1p2"; preLVM = true; allowDiscards = true; }
  ];

  networking.hostName = "xor";
  networking.networkmanager.enable = true;

  i18n = {
    consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-u22n.psf.gz";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    acpilight
    curl
    emacsHEAD
    git
    vim
  ];

  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
    KEYBOARD_KEY_3a=leftctrl
  '';

  services.cron.enable = true;
  services.timesyncd.enable = true;
  services.tlp.enable = true;

  environment.variables.XCURSOR_SIZE = "128";

  services.xserver = {
    enable = true;
    layout = "gb";
    dpi = 144;
    libinput.enable = true;
    videoDrivers = [ "intel" ];
    desktopManager.default = "none";
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "ts";
    windowManager.stumpwm.enable = true;
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      google-fonts
      terminus_font
    ];
  };

  sound.enable = true;
  services.upower.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.brightnessctl.enable = true;

  users.users.ts = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "networkmanager"
      "systemd-journal"
      "video"
      "wheel"
    ];
  };

  system.stateVersion = "19.03";
}
