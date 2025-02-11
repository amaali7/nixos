{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.hyprland;
in {
  options.amaali7.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable hyprland .";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = enabled;
    };
    environment.systemPackages = with pkgs; [
      kdePackages.polkit-kde-agent-1
      kdePackages.qt6ct
      kdePackages.dolphin
      gammastep
      bc
      kdePackages.systemsettings
      fish
      gnome-bluetooth
      strawberry
      nwg-look
      blueman
      qt6Packages.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      kdePackages.konsole
      kdePackages.plasma-workspace
      kdePackages.kconfig
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
      gnome-bluetooth
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
      inputs.ags.packages.${pkgs.system}.agsFull
    ];

  };
}
