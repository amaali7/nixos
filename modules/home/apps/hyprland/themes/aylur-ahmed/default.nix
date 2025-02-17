{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.hyprland.themes.aylur-ahmed;
in {
  options.amaali7.apps.hyprland.themes.aylur-ahmed = { enable = mkEnableOption "Hyprland Themes"; };

  config = mkIf cfg.enable {
    amaali7 = {
      apps = {
        hyprland.extra.plasma = enabled;
      };
    };
    home = {
      packages = with pkgs; [
      gammastep
      bc
      fish
      gnome-bluetooth
      strawberry
      nwg-look
      blueman
      # qt6Packages.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
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
      inputs.ags.packages.${pkgs.system}.ags
      ];
      activation.linkMyFiles =
        config.lib.dag.entryAfter [ "writeBoundary" ] ''
          # Config
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/hypr/ $HOME/.config/hypr
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/ags/ $HOME/.config/ags
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/easyeffects/ $HOME/.config/easyeffects
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/Kvantum/ $HOME/.config/Kvantum
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/qt5ct/ $HOME/.config/qt5ct
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/qt6ct/ $HOME/.config/qt6ct
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/wofi/ $HOME/.config/wofi
          ln -snf $HOME/.dotfiles/aylur-ahmed/config/gammastep.conf $HOME/.config/gammastep.conf
          # Local
          ln -snf $HOME/.dotfiles/aylur-ahmed/local/share/konsole/ $HOME/.local/share/konsole
          ln -snf $HOME/.dotfiles/aylur-ahmed/local/share/color-schemes/ $HOME/.local/share/color-schemes
          # Fonts
          ln -snf $HOME/.dotfiles/aylur-ahmed/fonts/ $HOME/.fonts
          ln -snf $HOME/.dotfiles/aylur-ahmed/ahmed-config.json  $HOME/.ahmed-config.json
        '';
    };
  };
}
