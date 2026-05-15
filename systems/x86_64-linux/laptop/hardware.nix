{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [
    "crc32" # Required for F2FS fsck
    "ext4" # Ensure ext4 is available in initrd
    "nvme" # Required if your drive is NVMe
    "xhci_pci"
    "ahci"
    "usb_storage"
    "uas"
    "sd_mod"
    "btrfs"
  ];
  boot.kernelParams = [ "fsck.mode=force" "fsck.repair=yes" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.plymouth.enable = true;
  boot.initrd.supportedFilesystems = [ "btrfs" ];
  boot.initrd.systemd.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dcb33e21-8f87-4387-bd06-02043c51923a";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  boot.initrd.luks.devices."main" = {
    device = "/dev/disk/by-uuid/0ab850d4-fc0f-40cb-98af-67f1fe69584e";
    allowDiscards = true;
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/dcb33e21-8f87-4387-bd06-02043c51923a";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };
  fileSystems."/home/ai3wm/Data" = {
    device = "/dev/disk/by-uuid/6EAC4D0056D72436";
    fsType = "ntfs";
    options = [ "nofail" "x-systemd.automount" ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/dcb33e21-8f87-4387-bd06-02043c51923a";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A896-FC69";
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
