{ pkgs, config, lib, modulesPath, inputs, ... }:

with lib;
with lib.amaali7; {
  amaali7 = {
    archtypes = {
      rpi = enabled;
      server = enabled;
    };
    system = {
      boot = {
        # Raspberry Pi requires a specific bootloader.
        enable = mkForce false;
      };
    };
  };
  imports = [
    # This module installs the firmware
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
    (inputs.nixos-hardware.outputs.nixosModules.raspberry-pi-3)
  ];

  # Add your username and ssh key
  # users.users.nixos = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  #   # openssh.authorizedKeys.keys = [ "YOUR_SSH_PUBLIC_KEY" ];
  # };

  system.stateVersion = "24.11";
}
