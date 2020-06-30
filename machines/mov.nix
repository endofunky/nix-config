{ config, pkgs, ... }:

{
  networking.hostName = "mov";

  boot = {
    initrd.luks.devices = {
      root = { 
        device = "/dev/nvme0n1p2"; 
        preLVM = true; 
        allowDiscards = true; 
      };
    };

    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  console.packages = with pkgs; [
    terminus_font
  ];

  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u22n.psf.gz";

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    device = "TPPS/2 Elan TrackPoint";
  };
}
