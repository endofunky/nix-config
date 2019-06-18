{ config, pkgs, lib, ... }:

let
  emacsHEAD = import ./pkgs/emacs.nix;
in
{
  imports = [
    ./hardware-configuration.nix
  ] ++ lib.optionals (builtins.pathExists ./configuration.local.nix) [
    ./configuration.local.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.earlyVconsoleSetup = true;
  boot.kernel.sysctl."vm.max_map_count" = 262144;

  networking.networkmanager.enable = true;
  networking.extraHosts = "127.0.0.1 ${config.networking.hostName}.local";

  i18n = {
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  time.timeZone = "Europe/London";

  environment.systemPackages = with pkgs; [
    acpilight
    curl
    exfat
    pamix
    vim
    wirelesstools
  ];

  services.autorandr.enable = true;
  services.cron.enable = true;
  services.timesyncd.enable = true;
  services.upower.enable = true;

  powerManagement.cpuFreqGovernor = null;
  services.tlp.enable = true;

  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:*
    KEYBOARD_KEY_3a=leftctrl
  '';

  services.xserver = {
    enable = true;
    layout = "gb";
    libinput.enable = true;
    videoDrivers = [ "intel" ];
    desktopManager.default = "none";
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "ts";
  };

  system.activationScripts.binbash = {
    text = "ln -sf ${pkgs.bash}/bin/bash /bin/bash";
    deps = [];
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      google-fonts
    ];
  };

  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.brightnessctl.enable = true;

  users.users.ts = {
    isNormalUser = true;
    shell = pkgs.zsh;
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
