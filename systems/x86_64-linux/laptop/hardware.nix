{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.plymouth.enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/dcb33e21-8f87-4387-bd06-02043c51923a";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."main".device = "/dev/disk/by-uuid/0ab850d4-fc0f-40cb-98af-67f1fe69584e";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/dcb33e21-8f87-4387-bd06-02043c51923a";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/dcb33e21-8f87-4387-bd06-02043c51923a";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A896-FC69";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };
    
  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024; # 16 GB ZRAM
  };
  swapDevices = [ ];
  # virtualisation.docker.enable = true;
  # virtualisation.libvirtd.enable = true;
  #  hardware.pulseaudio.enable = true;
  #  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
  hardware.acpilight.enable = true;
  hardware = {
    graphics.enable32Bit = true;
    pulseaudio.support32Bit = true;
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
