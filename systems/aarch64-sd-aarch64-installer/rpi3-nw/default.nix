{ pkgs, config, lib, modulesPath, inputs, ... }:

with lib;
with lib.amaali7; {
  imports = [
    # This module installs the firmware
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    (inputs.nixos-hardware.outputs.nixosModules.raspberry-pi-3)
  ];

  nix = {
    settings = {
      # The nix-community cache has aarch64 builds of unfree packages,
      # which aren't in the normal cache
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = "nix-command flakes";
      http-connections = 50;
      warn-dirty = false;
      log-lines = 50;
      sandbox = "relaxed";
      auto-optimise-store = true;
      allowed-users = [ "nixos" ];
      trusted-users = [ "@wheel" ];

      keep-outputs = true;
      keep-derivations = true;

    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    # flake-utils-plus
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;

  };

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    config = { allowUnfree = true; };
  };

  # These options make the sd card image build faster
  boot.supportedFilesystems.zfs = lib.mkForce false;
  sdImage.compressImage = false;
  boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
  boot.kernelParams = [ "cma=320M" ];
  networking.hostName = "nixos-pc";
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
    extraServiceFiles.ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
  };
  networking.firewall.allowedUDPPorts = [ 5353 ];};
  services.zram-generator = {
    enable = true;
    settings.zram0 = {
      compression-algorithm = "zstd";
      zram-size = "ram * 2";
    };
  };
  environment.systemPackages = with pkgs; [
    i3lock
    i3blocks
    autotiling
    kitty
    lm_sensors
    smartmontools
    rofi
    libraspberrypi
    raspberrypi-eeprom
    zellij
    git
    nixfmt-classic
    nix-index
    nix-prefetch-git
    nix-prefetch-github
    nix-output-monitor
    nixpkgs-fmt
    nixd
    nil
    # rnix-lsp
    stdenv

  ];
  services = {
    xserver = {
      displayManager.startx.enable = true;
      enable = true;
      windowManager.i3 = enabled;
    };
  };
  # Replace networkd with NetworkManager at your discretion
  networking = { };
  networking = {
    useNetworkd = true;
    interfaces."wlan0".useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      # ! Change the following to connect to your own network
      networks = {
        "WE_A65D68" = { # SSID
          psk = "n9v16300"; # password
        };
      };
    };
  };

  # Add your username and ssh key
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    # openssh.authorizedKeys.keys = [ "YOUR_SSH_PUBLIC_KEY" ];
  };

  # Our user doesn't have a password, so we let them
  # do sudo without one
  security.sudo.wheelNeedsPassword = false;

  services = { openssh.enable = true; };

  # Set your timezone
  # time.timeZone = "YOUR_TIMEZONE";

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "24.11";
}
