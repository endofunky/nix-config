{ config, pkgs, ... }:

with import <nixpkgs> {};

{
  programs.ssh = {
    enable = true;

    controlMaster = "auto";
    controlPath = "/tmp/ssh-%u-%r@%h:%p";
    controlPersist = "1800";
    compression = true;
    hashKnownHosts = true;
    serverAliveInterval = 10;
    extraConfig = ''
      Protocol 2
      TCPKeepAlive yes
      VerifyHostKeyDNS yes
      AddKeysToAgent yes
    '';

    extraOptionOverrides = {
      "Include" = "config.d/*";
    };
  };
}

