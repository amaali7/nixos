{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.enlightenment;
in {
  options.amaali7.desktop.enlightenment = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable Enlightenment Desktop Manager.";
  };

  config = mkIf cfg.enable {
    services.acpid = enabled;
    services.clipmenu = enabled;
    services.xserver = {
      enable = true;
      desktopManager.enlightenment = { enable = true; };
    };
    amaali7 = {
      desktop = {
        common-tiling = enabled;
        themes = enabled;
        xfce = enabled;
      };
      home = {
        extraOptions = {
          home.packages = with pkgs; [
            lm_sensors
            smartmontools
            imagemagick
            sassc
            material-icons
            material-symbols
            enlightenment.terminology
            enlightenment.rage
            enlightenment.evisum
            enlightenment.ephoto
            enlightenment.efl
            enlightenment.ecrire
            enlightenment.econnman
            e17gtk
            enlightenment.enlightenment
          ];
        };
      };
    };

  };
}
