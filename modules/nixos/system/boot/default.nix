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
    boot.loader.efi.canTouchEfiVariables = false;
    boot.loader.efi.efiSysMountPoint = "/boot";
    boot.plymouth = { enable = true; };
    boot.loader.systemd-boot = {
      enable = true;

      edk2-uefi-shell.enable = true;
      edk2-uefi-shell.sortKey = "z_edk2";
    };
    # for build raspberry pi image
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
