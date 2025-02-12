{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.hyprland;
in {
  options.amaali7.apps.hyprland = { enable = mkEnableOption "Hyprland"; };

  config = mkIf cfg.enable {
    # home.file."${config.xdg.configHome}" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${homeD}/.dotfiles/config/";
    #   recursive = true;
    # };
    # home.file.".local" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${homeD}/.dotfiles/local/";
    #   recursive = true;
    # };
    # home.file.".fonts" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${homeD}/.dotfiles/fonts/";
    #   recursive = true;
    # };
    home.activation.linkMyFiles =
      config.lib.dag.entryAfter [ "writeBoundary" ] ''
        # Config
        ln -sf $HOME/.dotfiles/config/hypr/ $HOME/.config/hypr
        ln -sf $HOME/.dotfiles/config/ags/ $HOME/.config/ags
        ln -sf $HOME/.dotfiles/config/easyeffects/ $HOME/.config/easyeffects
        ln -sf $HOME/.dotfiles/config/kvantum/ $HOME/.config/kvantum
        ln -sf $HOME/.dotfiles/config/qt5ct/ $HOME/.config/qt5ct
        ln -sf $HOME/.dotfiles/config/qt6ct/ $HOME/.config/qt6ct
        ln -sf $HOME/.dotfiles/config/wofi/ $HOME/.config/wofi
        ln -sf $HOME/.dotfiles/config/gammastep.conf $HOME/.config/gammastep.conf
        # Local
        ln -sf $HOME/.dotfiles/local/share/konsole/ $HOME/.local/share/konsole
        ln -sf $HOME/.dotfiles/local/share/color-schemes/ $HOME/.local/share/color-schemes
        # Fonts
        ln -sf $HOME/.dotfiles/fonts/ $HOME/.fonts
      '';
  };
}
