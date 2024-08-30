{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.mousai;
in {
  options.amaali7.apps.mousai = with types; {
    enable = mkBoolOpt false "Whether or not to enable mousai.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; with pkgs.amaali7; [ mousai ];
  };
}
