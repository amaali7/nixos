{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.ulauncher;
in {
  options.amaali7.apps.ulauncher = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ ulauncher ]; };
}