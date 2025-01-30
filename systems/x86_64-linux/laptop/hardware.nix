{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.plymouth.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/657ecc0a-8f0f-4803-9a5a-247172b9a008";
    fsType = "ext4";
  };

  boot.initrd = {
    luks.devices."root" = {
      device = "/dev/disk/by-uuid/9e56ed11-d281-4439-9b9d-a99eba30c275";
      preLVM = true;
      allowDiscards = true;
      keyFile = "/keyfile.bin";
    };
    luks.devices."nix-stor" = {
      device = "/dev/disk/by-uuid/17b41ea9-1038-479b-bdbc-147ed1940efe";
      keyFile = "/keyfile.bin";
      allowDiscards = true;
    };
    luks.devices."home" = {
      device = "/dev/disk/by-uuid/fdc0aa7c-f4b3-45d9-b4ff-466cb252e2d3";
      keyFile = "/keyfile.bin";
      allowDiscards = true;
    };
    secrets = { "keyfile.bin" = "/etc/secrets/initrd/keyfile.bin"; };
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/9894e4b7-33ef-4513-b0c0-5424ba8e464f";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/BD0C-B202";
    fsType = "vfat";
  };
  # my filesystems
  fileSystems."/home/ai3wm" = {
    device = "/dev/disk/by-uuid/4ce2e9eb-6bdb-4758-8c62-6a86aa23740c";
    fsType = "ext4";
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
