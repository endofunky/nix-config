{ config, pkgs, lib, ... }:

let
  docker-config = pkgs.writeText "daemon.json" (builtins.toJSON {
    bip = "10.110.0.1/24";
    default-address-pools = [
      {
        base = "10.111.0.0/16";
        size = 24;
      }
      {
        base = "10.112.0.0/16";
        size = 24;
      }
    ];
  });
in
{
  imports = [
    ./hardware-configuration.nix
  ] ++ lib.optionals (builtins.pathExists ./configuration.local.nix) [
    ./configuration.local.nix
  ] ++ lib.optionals (builtins.pathExists ./private/configuration.nix) [
    ./private/configuration.nix
  ];

  nixpkgs.config = import ./dotfiles/config.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.earlyVconsoleSetup = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "vm.max_map_count" = 262144;
  };
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  networking.networkmanager.enable = true;
  networking.extraHosts = "127.0.0.1 ${config.networking.hostName}.local";
  networking.usePredictableInterfaceNames = false;

  environment.etc."NetworkManager/system-connections/wired.nmconnection" = {
    source = ./etc/wired.nmconnection;
    mode = "0400";
  };

  environment.etc."oidentd.conf" = {
    source = ./etc/oidentd.conf;
    mode = "0644";
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
    killall
    pamix
    rfkill
    telnet
    vim
    wirelesstools
    xorg.xhost

    # Documentation
    man-pages       # Linux man pages
    posix_man_pages # POSIX man pages
    stdmanpages     # GCC C++ STD manual pages
  ];

  services.autorandr.enable = true;
  services.cron.enable = true;
  services.timesyncd.enable = true;
  services.upower.enable = true;
  services.oidentd.enable = true;

  powerManagement.cpuFreqGovernor = null;
  services.tlp.enable = true;

  virtualisation.docker = {
    enable = true;
    extraOptions = "--config-file=${docker-config}";
  };
  virtualisation.libvirtd.enable = true;

  systemd.extraConfig = "DefaultLimitNOFILE=1048576";

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
    enableCtrlAltBackspace = true;
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
  hardware.brightnessctl.enable = true;
  hardware.bluetooth = {
    enable = true;
    extraConfig = ''
      [General]
      Enable=Source,Sink,Media,Socket
    '';
  };
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

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
      "libvirtd"
      "networkmanager"
      "oidentd"
      "rfkill"
      "systemd-journal"
      "video"
      "wheel"
    ];
  };

  system.stateVersion = "19.03";
}
