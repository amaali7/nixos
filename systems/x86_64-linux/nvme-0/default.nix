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
  };
  system.stateVersion = "25.11";
}
