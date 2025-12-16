{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  cfg = config.amaali7.apps.niri.extra;
in {
  options.amaali7.apps.niri.extra = { enable = mkEnableOption "Niri Themes"; };

  config = mkIf cfg.enable { home = { packages = with pkgs; [ ]; }; };
}
