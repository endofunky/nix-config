{ config, pkgs, ... }:

{
  networking.hostName = "xor";

  boot = {
    initrd.luks.devices = [
      { name = "root"; device = "/dev/nvme0n1p2"; preLVM = true; allowDiscards = true; }
    ];

    kernelModules = [ "acpi_call" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };

  i18n = {
    consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-u22n.psf.gz";
    consolePackages = with pkgs; [
      terminus_font
    ];
  };
}
