{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.brave;
in {
  options.amaali7.apps.brave = with types; {
    enable = mkBoolOpt false "Whether or not to enable brave.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ brave ]; };
}
