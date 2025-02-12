{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.plasma;
in {
  options.amaali7.desktop.plasma = with types; {
    enable = mkBoolOpt false "Whether or not to enable plasma.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.krohnkite
      qt6Packages.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
    ];
  };
}
