{ inputs, lib, config, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.cli-apps.superfile;
in {
  options.amaali7.cli-apps.superfile = with types; {
    enable = mkBoolOpt false "Whether or not to enable superfile.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [ inputs.superfile.packages.${pkgs.system}.superfile ];
  };
}
