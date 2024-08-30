{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.hyprland;
in {
  options.amaali7.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = { enable = true; };
    };
    # wayland.windowManager.hyprland = {
    #   enable = true;
    #   # ...
    #   plugins = [
    #     inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    #     # ...
    #   ];
    # };

    programs.waybar = enabled;
    services.xserver.displayManager.gdm.wayland = true;
    environment.sessionVariables = { QT_QPA_PLATFORMTHEME = "qt5ct"; };
    amaali7 = {
      cli-apps = {
        matugen = enabled;
      };
      apps.ags = enabled;
      desktop = {
        common-tiling = enabled;
        themes = enabled;
        wayland = enabled;
        xfce = enabled;
      };
      home = {
        extraOptions = {
          home.packages = with pkgs; [
           slurp
wf-recorder wayshot hyprpicker
libadwaita
            libsForQt5.polkit-kde-agent
            libsForQt5.qt5ct
            qt6Packages.qt6ct
            libsForQt5.dolphin
            gammastep
            bc
            libsForQt5.systemsettings
            fish
            gnome.gnome-bluetooth
            strawberry
            nwg-look
            blueman
            qt6Packages.qtstyleplugin-kvantum
            libsForQt5.qtstyleplugin-kvantum
            libsForQt5.konsole
            libsForQt5.plasma-workspace
            libsForQt5.kconfig
            glib
            gsettings-qt
            bun
            # ------
            foot
            grim
            slurp
            swww
            fish
            light
            swaylock-effects
            swayidle
            theme-sh
            xdg-desktop-portal-hyprland
            starship
            cava
            imagemagick
            gnome.gnome-bluetooth
            libdbusmenu-gtk3
            wl-clipboard
            # ------
            wofi
            swaybg
            wlsunset

            wl-gammactl
            wl-clipboard
            wf-recorder
            hyprpicker
            imagemagick
            hyprpaper
            slurp
            kitty
            sassc
            watershot

            hyprland
            hyprland-protocols
            # hyprland-share-picker
            xdg-desktop-portal-hyprland
            wlprop
            inputs.hyprland-contrib.packages.${pkgs.system}.hyprprop
            # inputs.kmyc.defaultPackage.${pkgs.system}
          ];
        };
      };
    };
  };
}
