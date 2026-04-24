{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.rofi;
in {
  options.amaali7.apps.rofi = { enable = mkEnableOption "Caelestia"; };

  config = mkIf cfg.enable {
    rofi = enabled;
    home = {
      programs.rofi = {
        enable = true;
        plugins = with pkgs; [
          rofimoji
          rofi-calc
          rofi-nerdy
          rofi-menugen
          rofi-screenshot
          rofi-file-browser
          rofi-pulse-select
          rofi-network-manager
          rofi-top
        ];
        pass = { enable = true; };
      };
    };
  };
}
