{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.playonlinux;
in {
  options.amaali7.apps.playonlinux = with types; {
    enable = mkBoolOpt false "Whether or not to enable PCSX2.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ playonlinux ]; };
}
