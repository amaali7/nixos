{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.i3wm;
in {
  options.amaali7.desktop.i3wm = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3wm .";
  };

  config = mkIf cfg.enable {
    amaali7 = {
      apps = { nemo = enabled; };
      desktop = {
        themes = enabled;
        xfce = enabled;
        x11 = enabled;
      };
    };
    environment.pathsToLink = [
      "/libexec"
    ]; # links /libexec from derivations to /run/current-system/sw
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;

      desktopManager = { xterm.enable = false; };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3blocks # if you are planning on using i3blocks over i3status
          i3lock-fancy-rapid
          i3lock-fancy
          i3blocks
          i3wsr
          lm_sensors
          xtitle
          gawk
          gnugrep
          lxappearance
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          lm_sensors
          smartmontools
          kitty
        ];
      };
    };

    services.displayManager.defaultSession = "none+i3";

    programs.i3lock.enable = true; # default i3 screen locker
  };
}
