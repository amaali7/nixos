{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.tools.http;
in {
  options.amaali7.tools.http = with types; {
    enable = mkBoolOpt false "Whether or not to enable common http utilities.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ wget curl ]; };
}
