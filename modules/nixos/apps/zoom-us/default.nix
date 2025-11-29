{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.zoom-us;
in {
  options.amaali7.apps.zoom-us = with types; {
    enable = mkBoolOpt false "Whether or not to enable zoom-us.";
  };

  config = mkIf cfg.enable { programs.zoom-us.enable = true; };
}
