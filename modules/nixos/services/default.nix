{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.services;
in {
  options.amaali7.services = with types; {
    enable = mkBoolOpt false "Whether or not to enable services.";
  };

  config = mkIf cfg.enable {
    # systemd = {
    #   user.services.polkit-gnome-authentication-agent-1 = {
    #     description = "polkit-gnome-authentication-agent-1";
    #     wantedBy = [ "graphical-session.target" ];
    #     wants = [ "graphical-session.target" ];
    #     after = [ "graphical-session.target" ];
    #     serviceConfig = {
    #       Type = "simple";
    #       ExecStart =
    #         "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    #       Restart = "on-failure";
    #       RestartSec = 1;
    #       TimeoutStopSec = 10;
    #     };
    #   };
    # };
    security.polkit.enable = true;
    amaali7 = { apps = { avahi = enabled; }; };
    # enable location service
    location.provider = "geoclue2";
    # from amaali7
    services = {
      pulseaudio = {
        enable = false;
        # support32Bit = true;
      };
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
    services.displayManager.autoLogin = {
      enable = true;
      user = "ai3wm";
    };
    # system.activationScripts.gdmTheme =
    #   let nordShellTheme = "${pkgs.nordic}/share/themes/Nordic/gnome-shell";
    #   in ''
    #     rm -rf /run/current-system/etc/xdg/gdm3/shell-theme.gresource
    #     cp -f ${nordShellTheme}/gnome-shell.css /etc/xdg/gdm3/gnome-shell.css
    #     cp -f ${nordShellTheme}/gnome-shell-theme.gresource /etc/xdg/gdm3/
    #   '';
    services.xserver.displayManager = { gdm = enabled; };
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
