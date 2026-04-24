{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.xfce;
in {
  options.amaali7.desktop.xfce = with types; {
    enable = mkBoolOpt false "Whether or not to enable xfce.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.xfce;

      [
        xfce4-power-manager
        thunar
        thunar-volman
        thunar-archive-plugin
        thunar-media-tags-plugin
        tumbler
        ristretto
      ] ++ (with pkgs; [ gvfs glib cmd-polkit lxqt.lxqt-policykit ]);
    services = {
      gvfs.enable = true;
      tumbler = enabled;
      udisks2 = enabled;
      upower = enabled;
      gnome.at-spi2-core = enabled;
      dbus = enabled;
    };

    systemd.user.services.polkit-agent = {
      description = "Polkit Agent";
      wantedBy = [ "default.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "always";
      };
    };
    # systemd.user.services.gvfs-daemon = {
    #   description = "GVFS Daemon";
    #   wantedBy = [ "default.target" ];
    #   after = [ "dbus.service" ];

    #   serviceConfig = {
    #     ExecStart = "${pkgs.gvfs}/libexec/gvfsd";
    #     Restart = "on-failure";
    #   };
    # };
    # systemd.user.services.gvfs-udisks2-monitor = {
    #   description = "GVFS UDisks2 Volume Monitor";
    #   wantedBy = [ "default.target" ];
    #   after = [ "gvfs-daemon.service" ];

    #   serviceConfig = {
    #     ExecStart = "${pkgs.gvfs}/libexec/gvfs-udisks2-volume-monitor";
    #     Restart = "on-failure";
    #   };
    # };
    systemd.user.services.thunar-daemon = {
      description = "Thunar Daemon";
      wantedBy = [ "default.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.xfce.thunar}/bin/thunar --daemon";
      };
    };
    security.polkit = enabled;
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
    # critical for GDM + non-GNOME WMs
    services.xserver.displayManager.sessionCommands = ''
      systemctl --user import-environment \
        DISPLAY \
        XAUTHORITY \
        DBUS_SESSION_BUS_ADDRESS \
        XDG_CURRENT_DESKTOP

      dbus-update-activation-environment --systemd \
        DISPLAY \
        XAUTHORITY \
        DBUS_SESSION_BUS_ADDRESS \
        XDG_CURRENT_DESKTOP
    '';
  };
}
