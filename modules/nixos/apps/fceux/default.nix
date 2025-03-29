{ pkgs, config, lib, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.fceux;
in {
  options.amaali7.apps.fceux = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ fceux ]; };
}
