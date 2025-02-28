{ options, config, pkgs, lib, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.system.boot;
in {
  options.amaali7.system.boot = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
  };

  config = mkIf cfg.enable {
    # Bootloader.
    boot.loader.efi.canTouchEfiVariables = true;
    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
    # boot.loader.grub = {
    #   enable = true;
    #   device = "nodev";
    #   efiSupport = true;
    #   enableCryptodisk = true;
    #   useOSProber = true;
    # };
    boot.loader.systemd-boot = {
      enable = true;

      windows = {
        "windows" = let
          # To determine the name of the windows boot drive, boot into edk2 first, then run
          # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
          # which alias corresponds to which EFI partition.
          boot-drive = "FS1";
        in {
          title = "Windows";
          efiDeviceHandle = boot-drive;
          sortKey = "y_windows";
        };
      };

      edk2-uefi-shell.enable = true;
      edk2-uefi-shell.sortKey = "z_edk2";
    };
    boot.plymouth = { enable = true; };
    # for build raspberry pi image 
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
