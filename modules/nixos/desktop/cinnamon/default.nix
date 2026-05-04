{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.cinnamon;
in {
  options.amaali7.desktop.cinnamon = with types; {
    enable = mkBoolOpt false "Whether or not to enable cinnamon.";
  };

  config = mkIf cfg.enable {
    services.cinnamon.apps.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;
  };
}
