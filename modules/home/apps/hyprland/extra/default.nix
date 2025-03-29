{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  cfg = config.amaali7.apps.hyprland.extra;
in {
  options.amaali7.apps.hyprland.extra = { enable = mkEnableOption "Hyprland Themes"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [  ];
    };
  };
}
