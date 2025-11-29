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
    home = {
      packages = with pkgs;
        [ inputs.caelestia-shell.packages."${pkgs.system}".default ];
    };
  };
}
