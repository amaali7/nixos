{ pkgs, lib, inputs, ... }:

with lib;
with lib.amaali7; {
  imports = [ ./hardware.nix ];
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = "aarch64-linux";

  amaali7 = {
    archetypes = {
      workstation = enabled;
      gaming = enabled;
    };
    system.boot = mkForce disabled;
  };
  boot.loader.grub = {
      enable = true;
      efiSupport = false; # Crucial for MBR installations
      device = "/dev/sda"; # Replace with your target disk
      useOSProber = true; # Optional, for detecting other OSes
    };
  system.stateVersion = "25.05";
}
