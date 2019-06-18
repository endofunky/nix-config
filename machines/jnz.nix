{ config, pkgs, ... }:

{
  networking.hostName = "jnz";

  boot = {
    initrd.luks.devices = [
      { name = "root"; device = "/dev/nvme0n1p2"; preLVM = true; allowDiscards = true; }
    ];
  };

  boot.kernelParams = [ "intel_idle.max_cstate=4" ];
}
