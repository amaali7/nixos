{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.ventoy;
in {
  options.amaali7.apps.ventoy = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable { environment.systemPackages = [ ventoy-full ]; };
}
