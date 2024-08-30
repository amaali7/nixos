{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.exwm;
in {
  options.amaali7.desktop.exwm = with types; {
    enable = mkBoolOpt false "Whether or not to enable sway.";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.exwm = {
      enable = true;
      enableDefaultConfig = true;
    };
  };
}
