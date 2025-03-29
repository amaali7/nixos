{ inputs, lib, config, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.cli-apps.matugen;
in {
  options.amaali7.cli-apps.matugen = with types; {
    enable = mkBoolOpt false "Whether or not to enable mutugen.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = [ inputs.matugen.packages.${pkgs.system}.default ]; };
}
