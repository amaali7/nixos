{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.niri;
in {
  options.amaali7.desktop.niri = with types; {
    enable = mkBoolOpt false "Whether or not to enable niri .";
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
    programs.niri = { enable = true; };
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      lm_sensors
      smartmontools
      kitty 
    ];

    systemd.user.services.niri-flake-polkit.enable = false;
  };
}
