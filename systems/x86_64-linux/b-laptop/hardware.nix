{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/027e6c60-3f19-4c28-b53e-7e3d92afad2b";
      fsType = "btrfs";
      options = [ "subvol=@root" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/027e6c60-3f19-4c28-b53e-7e3d92afad2b";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/027e6c60-3f19-4c28-b53e-7e3d92afad2b";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
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
