{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.archtypes.rpi;
in {
  options.amaali7.archtypes.rpi = with types; {
    enable = mkBoolOpt false "Whether or not to enable the rpi archetype.";
  };

  config = mkIf cfg.enable {
    boot = {
      # kernelPackages = pkgs.linuxKernel.kernels.linux_rpi3;
      kernelParams = [ "cma=256M" "console=ttyS1,115200n8" ];
      initrd = {
        # availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
        availableKernelModules = [ "xhci_pci" ];
        kernelModules = [ "vc4" "bcm2835_dma" "bcm2835-v4l2" "i2c_bcm2835" ];

      };
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
        raspberryPi = {
          firmwareConfig = ''
            dtparam=audio=on
            start_x=1
            gpu_mem=256
          '';
          enable = true;
          version = 3;
          uboot.enable = true;
        };
      };
    };
    systemd.services.btattach = {
      before = [ "bluetooth.service" ];
      after = [ "dev-ttyAMA0.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
      };
    };
    hardware.enableRedistributableFirmware = true;
    services = {
      desktopManager.plasma6.enable = true;
      xserver = {
        enable = true;
        displayManager.sddm.enable = true;
      };
    };
    networking.wireless = disabled;
    amaali7 = {
      nix = enabled;
      shell.zsh = enabled;
      hardware.networking = enabled;
      cli-apps = {
        neovim = enabled;
        zellij = enabled;
      };
      tools.git = enabled;
      user = {
        name = "pi";
        initialPassword = "pi";
        # group = "wheel";
        # isNormalUser = true;
      };
    };
  };
}
