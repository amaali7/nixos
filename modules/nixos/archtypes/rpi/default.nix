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
    boot.tmp.useTmpfs = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
      };
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
            pskRaw =
              "ca7d9219fb8157cf6a10ce4b2e6c4fd412ce731dd94a647c27d85ba705c58446"; # password
          };
        };
      };
    };

    # Add your username and ssh key
    users.users.nixos = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqVEqyHNIvReezSYd11qD/H7X2XhPKIt+yPeTFqp96N amaali1991@gmail.com"
      ];
      extraGroups = [
        "wheel"
        "storage"
        "plugdev"
        "disk"
        "wheel"
        "dialout"
        "network"
        "docker"
        "adbusers"
        "kvm"
      ];
    };

    hardware.enableRedistributableFirmware = true;
    amaali7 = {
      develop.rust-rpi = enabled;
      cli-apps = {
        superfile = enabled;
        zellij = enabled;
      };
      shell.nushell = enabled;
      tools = {
        git = enabled;
        misc = enabled;
        fup-repl = enabled;
        comma = enabled;
        nix-ld = enabled;
        bottom = enabled;
        cli = enabled;
        # archive = enabled;
      };

    };
  };
}
