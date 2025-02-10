{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.services;
in {
  options.amaali7.services = with types; {
    enable = mkBoolOpt false "Whether or not to enable services.";
  };

  config = mkIf cfg.enable {
    # enable location service
    location.provider = "geoclue2";
    # from amaali7
    services = {
      # provide location
      geoclue2.enable = true;

      power-profiles-daemon.enable = true;

      # profile-sync-daemon
      psd = {
        enable = true;
        resyncTimer = "10m";
      };

      # battery info & stuff
      upower.enable = true;

      # needed for GNOME services outside of GNOME Desktop
      dbus.packages = [ pkgs.gcr ];

      udev = {
        packages = with pkgs; [ gnome-settings-daemon ];
        extraRules = ''
          # add my android device to adbusers
          SUBSYSTEM=="usb", ATTR{idVendor}=="22d9", MODE="0666", GROUP="adbusers"
        '';
      };
    };

    systemd.services.ModemManager.enable = true;
    services.postgresql.enable = true;
    services.teamviewer.enable = true;
    services.libinput.enable = true;
    services.displayManager = {
      autoLogin = {
        enable = true;
        user = "ai3wm";
      };
      sddm = {
        enable = true;
        wayland = disabled;
        # package = pkgs.kdePackages.sddm;
        # extraPackages = with pkgs;
        #   [
        #     kdePackages.qtsvg
        #     sddm-astronaut
        #     kdePackages.ffmpegthumbs
        #     kdePackages.qtvirtualkeyboard
        #   ];
        # theme = "cyberpunk";
      };
    };
    services.xserver = enabled;
    services.gvfs.enable = true;
    services.acpid.enable = true;
    services.printing.enable = true;
    services.openssh.enable = true;
    services.geoclue2.appConfig = {
      "com.github.app" = {
        isAllowed = true;
        isSystem = false;
        users = [ "1000" ];
      };
    };
  };
}
