{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.suites.desktop;
in {
  options.amaali7.suites.desktop = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common desktop configuration.";
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.amaali7.deepseek-cli ];
    programs.dconf.enable = true;
    amaali7 = {
      desktop = {
        i3wm = enabled;
        hyprland = enabled;
      };

      apps = {
        firefox = enabled;
        zen = enabled;
        vlc = enabled;
        logseq = enabled;
        gparted = enabled;
      };
    };
  };
}
