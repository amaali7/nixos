{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.ags;
in {
  options.amaali7.apps.ags = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ inputs.ags.packages.${pkgs.system}.ags ];
  };
}
