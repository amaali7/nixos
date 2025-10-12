{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.caprine;
in {
  options.amaali7.apps.caprine = with types; {
    enable = mkBoolOpt false "Whether or not to enable doukutsu-rs.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ caprine ]; };
}
