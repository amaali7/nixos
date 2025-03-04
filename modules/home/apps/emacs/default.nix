{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.apps.emacs;
in {
  options.amaali7.apps.emacs = { enable = mkEnableOption "emacs"; };

  config =
    mkIf cfg.enable { amaali7 = { apps = { emacs.config.doom = enabled; }; }; };
}
