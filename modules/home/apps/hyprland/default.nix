{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.apps.hyprland;
in {
  options.amaali7.apps.hyprland = { enable = mkEnableOption "Hyprland"; };

  config = mkIf cfg.enable {
        home.packages = with pkgs; [
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
          wayland.windowManager.hyprland = {
            enable = true;
            xwayland = enabled;
            # plugins =
            #   [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars ];
          };
        };
}
