{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.archtypes.rpi;
in {
  options.amaali7.archtypes.rpi = with types; {
    enable = mkBoolOpt false "Whether or not to enable the rpi archetype.";
  };

  config = mkIf cfg.enable {
    # boot.kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi3;

    # fix the following error :
    # modprobe: FATAL: Module ahci not found in directory
    # https://github.com/NixOS/nixpkgs/issues/154163#issuecomment-1350599022
    nixpkgs.overlays = [
      (_final: super: {
        makeModulesClosure = x:
          super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];

    # https://github.com/NixOS/nixpkgs/blob/b72bde7c4a1f9c9bf1a161f0c267186ce3c6483c/nixos/modules/installer/sd-card/sd-image-aarch64.nix#L12
    # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
    boot.loader.grub.enable = lib.mkDefault false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;

    # The last console argument in the list that linux can find at boot will receive kernel logs.
    # The serial ports listed here are:
    # - ttyS0: serial
    # - tty0: hdmi
    boot.kernelParams = [ "console=ttyS0,115200n8" "console=tty0" ];
    documentation.nixos.enable = false;
    nix.settings.trusted-users = [ "@wheel" ];
    services.zram-generator = {
      enable = true;
      settings.zram0 = {
        compression-algorithm = "zstd";
        zram-size = "ram * 2";
      };
    };
    boot = {
      # kernelPackages = pkgs.linuxKernel.kernels.linux_rpi3;
      kernelPackages = pkgs.linuxPackages_rpi3.extend (self: super: {
        kernel = super.kernel.override {
          # Your overrides here
          modDirVersion = "6.6.31-v8";
        };
      });
      # kernelParams = [ "cma=256M" "console=ttyS1,115200n8" ];
      initrd = {
        # availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
        availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
        kernelModules = [ "vc4" "bcm2835_dma" "bcm2835-v4l2" "i2c_bcm2835" ];

      };
      # loader = {
      #   grub.enable = false;
      #   generic-extlinux-compatible.enable = true;
      # };
      # Avoids warning: mdadm: Neither MAILADDR nor PROGRAM has been set.
      # This will cause the `mdmon` service to crash.
      # See: https://github.com/NixOS/nixpkgs/issues/254807
      swraid.enable = lib.mkForce false;
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
    networking = { };
    networking = {
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
    environment.systemPackages = with pkgs; [
      htop
      vim
      emacs
      ripgrep
      btop
      # (python311.withPackages (p:
      #   with p; [
      #     python311Packages.rpi-gpio
      #     python311Packages.gpiozero
      #     python311Packages.pyserial
      #   ]))
      usbutils
      tmux
      git
      dig
      tree
      bintools
      lsof
      pre-commit
      file
      bat
      ethtool
      minicom
      fast-cli
      nmap
      openssl
      dtc
      zstd
      neofetch
    ];
    # Keep this to make sure wifi works
    hardware.enableRedistributableFirmware = lib.mkForce false;
    hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      xserver = { enable = true; };
    };
    users.mutableUsers = false;
    # Enable OpenSSH out of the box.
    services.sshd.enable = true;
    # NTP time sync.
    services.timesyncd.enable = true;
    # ! Be sure to change the autologinUser.
    # services.getty.autologinUser = lib.mkForce "pi";
    amaali7 = {
      nix = enabled;
      shell.zsh = enabled;
      cli-apps = { zellij = enabled; };
      tools.git = enabled;
      user = {
        name = "nixos";
        # initialPassword = "nixos";
        extraOptions = {
          group = "wheel";
          isNormalUser = true;
        };
      };
    };
  };
}
