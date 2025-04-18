{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.hyprland.themes;
in {
  options.amaali7.apps.hyprland.themes = { enable = mkEnableOption "Hyprland Themes"; };

  config = mkIf cfg.enable {
  };
}
