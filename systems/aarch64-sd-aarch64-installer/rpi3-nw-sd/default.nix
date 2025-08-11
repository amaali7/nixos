{ pkgs, config, lib, modulesPath, inputs, ... }:

with lib;
with lib.amaali7; {
  imports = [
    # This module installs the firmware
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    (inputs.nixos-hardware.outputs.nixosModules.raspberry-pi-3)
  ];

  amaali7 = {
    archtypes = {
      rpi = enabled;
      # server = enabled;
    };
    system = {
      boot = {
        # Raspberry Pi requires a specific bootloader.
        enable = mkForce false;
      };

    };
    hardware = {
      storage = mkForce disabled;
      networking = mkForce disabled;
    };
    nix = {
      enable = true;
      package = mkForce pkgs.nix;
    };
  };

  sdImage.compressImage = false;
  system.stateVersion = "25.05";
}
