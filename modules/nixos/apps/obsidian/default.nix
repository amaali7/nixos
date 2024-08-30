{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.obsidian;
in {
  options.amaali7.apps.obsidian = with types; {
    enable = mkBoolOpt false "Whether or not to enable obsidian.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; with pkgs.amaali7; [ obsidian ];
  };
}
