{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.caelestia;
in {
  options.amaali7.apps.caelestia = { enable = mkEnableOption "Caelestia"; };

  config = mkIf cfg.enable {
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = false; # if you prefer starting from your compositor
        target = "graphical-session.target";
        environment = [ ];
      };

      cli = {
        enable = true; # Also add caelestia-cli to path
        settings = { theme.enableGtk = false; };
      };
    };
    home = {
      # packages = with pkgs;
      #   [ inputs.caelestia-shell.packages."${pkgs.system}".default ];
    };
  };
}
