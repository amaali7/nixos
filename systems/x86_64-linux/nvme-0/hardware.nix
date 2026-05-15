{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # boot.initrd.availableKernelModules = [ ];
  # boot.initrd.kernelModules = [
  #   "crc32" # Required for F2FS fsck
  #   "ext4" # Ensure ext4 is available in initrd
  #   "nvme" # Required if your drive is NVMe
  #   "xhci_pci"
  #   "ahci"
  #   "usb_storage"
  #   "uas"
  #   "sd_mod"
  #   "btrfs"
  # ];
  # boot.initrd.supportedFilesystems = [ "btrfs" ];
  # boot.kernelParams = [ "fsck.mode=force" "fsck.repair=yes" ];
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ ];
  # boot.plymouth.enable = true;
  # boot.initrd.systemd.enable = true;

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/3afe7068-a2da-43b1-976b-cc7571094c42";
  #   fsType = "btrfs";
  #   options = [ "subvol=root" ];
  # };

  # boot.initrd.luks.devices."main" = {
  #   device = "/dev/disk/by-uuid/0ed8e710-59a4-43fa-b286-9d94f2d9efe8";
  #   allowDiscards = true;
  # };
  # fileSystems."/home" = {
  #   device = "/dev/disk/by-uuid/3afe7068-a2da-43b1-976b-cc7571094c42";
  #   fsType = "btrfs";
  #   options = [ "subvol=home" ];
  # };
  # fileSystems."/home/ai3wm/Data" = {
  #   device = "/dev/disk/by-uuid/6BAF69BB676F8D8F";
  #   fsType = "ntfs";
  #   options = [ "nofail" "x-systemd.automount" ];
  # };
  # fileSystems."/nix" = {
  #   device = "/dev/disk/by-uuid/3afe7068-a2da-43b1-976b-cc7571094c42";
  #   fsType = "btrfs";
  #   options = [ "subvol=nix" ];
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/264A-1681";
  #   fsType = "vfat";
  #   options = [ "fmask=0022" "dmask=0022" ];
  # };
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usbhid" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/0ed8e710-59a4-43fa-b286-9d94f2d9efe8";

  fileSystems."/home" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/264A-1681";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
  };
  swapDevices = [ ];
  hardware.acpilight.enable = true;
  hardware = {
    graphics.enable32Bit = true;

  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
