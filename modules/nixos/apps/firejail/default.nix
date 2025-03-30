{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.firejail;
in {
  options.amaali7.apps.firejail = with types; {
    enable = mkBoolOpt false "Whether or not to enable firejail.";
  };

  config = mkIf cfg.enable {
    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        librewolf = {
          executable = "${pkgs.librewolf}/bin/librewolf";
          profile = "${pkgs.firejail}/etc/firejail/librewolf.profile";
          extraArgs = [
            # Required for U2F USB stick
            "--ignore=private-dev"
            # Enforce dark mode
            "--env=GTK_THEME=Adwaita:dark"
            # Enable system notifications
            "--dbus-user.talk=org.freedesktop.Notifications"
          ];
          desktop = "${pkgs.librewolf}/share/applications/librewolf.desktop";
        };
        # signal-desktop = {
        #   executable =
        #     "${pkgs.signal-desktop}/bin/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland";
        #   profile = "${pkgs.firejail}/etc/firejail/signal-desktop.profile";
        #   extraArgs = [ "--env=GTK_THEME=Adwaita:dark" ];
        # };
      };
    };
    environment.etc = {
      "firejail/librewolf.local".text = ''
        # Enable native notifications.
        dbus-user.talk org.freedesktop.Notifications
        # Allow inhibiting screensavers.
        dbus-user.talk org.freedesktop.ScreenSaver
        # Allow screensharing under Wayland.
        dbus-user.talk org.freedesktop.portal.Desktop
      '';
    };
  };
}
