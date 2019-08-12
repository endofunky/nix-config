{ config, pkgs, lib, ... }:

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

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.networkmanager.enable = true;
  networking.extraHosts = "127.0.0.1 ${config.networking.hostName}.local";
  networking.usePredictableInterfaceNames = false;

  environment.etc."NetworkManager/system-connections/wired.nmconnection" = {
    text = ''
      [connection]
      id=wired
      type=ethernet
      interface-name=eth0

      [ipv4]
      method=auto

      [ipv6]
      addr-gen-mode=stable-privacy
      method=auto
    '';
    mode = "0400";
  };

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
    rfkill
    vim
    wirelesstools

    # Documentation
    man-pages       # Linux man pages
    posix_man_pages # POSIX man pages
    stdmanpages     # GCC C++ STD manual pages
  ];

  services.autorandr.enable = true;
  services.cron.enable = true;
  services.timesyncd.enable = true;
  services.upower.enable = true;

  powerManagement.cpuFreqGovernor = null;
  services.tlp.enable = true;

  virtualisation.docker.enable = true;

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

  security.sudo = {
    enable = true;
    extraConfig = ''
      %rfkill ALL=NOPASSWD: ${pkgs.rfkill}/bin/rfkill
    '';
  };

  users.users.ts = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "docker"
      "networkmanager"
      "rfkill"
      "systemd-journal"
      "video"
      "wheel"
    ];
  };

  system.stateVersion = "19.03";
}
