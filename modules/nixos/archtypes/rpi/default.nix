{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.archtypes.rpi;
in {
  options.amaali7.archtypes.rpi = with types; {
    enable = mkBoolOpt false "Whether or not to enable the rpi archetype.";
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
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
      };
    };
    nixpkgs = { config = { allowUnfree = true; }; };

    # These options make the sd card image build faster
    boot.supportedFilesystems.zfs = lib.mkForce false;
    boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
    boot.kernelParams = [ "cma=320M" ];
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
    networking.firewall.allowedUDPPorts = [ 5353 ];
    services.zram-generator = {
      enable = true;
      settings.zram0 = {
        compression-algorithm = "zstd";
        zram-size = "ram * 2";
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

    hardware.enableRedistributableFirmware = true;
  };
}
