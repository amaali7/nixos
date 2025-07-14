{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.hyprland;
in {
  options.amaali7.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable hyprland .";
  };


  config = mkIf cfg.enable {
	amaali7 = {
	desktop = {
	themes = enabled;
	xfce = enabled;
	wayland = enabled;
};
};
    hardware.graphics = {
      enable32Bit = true;
      enable = true;
    };
    environment.sessionVariables =
      lib.mkForce { QT_QPA_PLATFORMTHEME = "qtct"; };
    programs.hyprland = {
      enable = true;
      xwayland = enabled;
    };
    environment.systemPackages = with pkgs;
      [ hyprlock ] ++ (with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        waybar
            lm_sensors
            smartmontools
        ulauncher
      ]);

  };
}
