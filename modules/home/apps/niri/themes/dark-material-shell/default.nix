{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.niri.themes.dark-material-shell;
in {
  options.amaali7.apps.niri.themes.dark-material-shell = {
    enable = mkEnableOption "dark-material-shell";
  };

  config = mkIf cfg.enable {
    programs.dankMaterialShell = {
      enable = true;
      niri = {
        enableKeybinds = true; # Automatic keybinding configuration
        enableSpawn = true; # Auto-start DMS with niri
      };
      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged =
          true; # Auto-restart dms.service when dankMaterialShell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
    };

    home = {
      activation.linkNiriConfigFiles =
        config.lib.dag.entryAfter [ "writeBoundary" ] ''
          # Config
          ln -snf $HOME/.dotfiles/niri/ $HOME/.config/niri
        '';
    };
  };
}
