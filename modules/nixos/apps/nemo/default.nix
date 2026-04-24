{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.nemo;
in {
  options.amaali7.apps.nemo = with types; {
    enable = mkBoolOpt false "Whether or not to enable doukutsu-rs.";
  };

  config = mkIf cfg.enable {
    xdg = {
      mime.defaultApplications = {
        "inode/directory" = [ "nemo.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      };
    };
    environment.systemPackages = with pkgs;
      [
        (nemo-with-extensions.override {
          extensions = [
            nemo-seahorse
            nemo-python
            nemo-emblems
            nemo-preview
            nemo-fileroller
            nemo-qml-plugin-dbus
            folder-color-switcher
          ];
        })
      ];
    services.dbus.packages = with pkgs; [ libcryptui ];

    services.desktopManager.gnome.extraGSettingsOverridePackages = with pkgs; [
      nemo
      gcr
      libcryptui
      nemo-seahorse
    ];
  };
}
