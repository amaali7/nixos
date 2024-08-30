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
    amaali7 = {
      desktop = {
				# exwm = enabled;
        # hyprland = enabled;
        i3wm = enabled;
        # awesomewm = enabled;
        # cde = enabled;
        addons = {
        #   wallpapers = enabled;
           rofi = enabled;
         };
      };

      apps = {
        firefox = enabled;
        zen = enabled;
        brave = enabled;
        vlc = enabled;
        logseq = enabled;
        # twitter = enabled;
        gparted = enabled;
      };
    };
  };
}
