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
        ln -snf $HOME/.dotfiles/config/hypr/ $HOME/.config/hypr
        ln -snf $HOME/.dotfiles/config/ags/ $HOME/.config/ags
        ln -snf $HOME/.dotfiles/config/easyeffects/ $HOME/.config/easyeffects
        ln -snf $HOME/.dotfiles/config/kvantum/ $HOME/.config/kvantum
        ln -snf $HOME/.dotfiles/config/qt5ct/ $HOME/.config/qt5ct
        ln -snf $HOME/.dotfiles/config/qt6ct/ $HOME/.config/qt6ct
        ln -snf $HOME/.dotfiles/config/wofi/ $HOME/.config/wofi
        ln -snf $HOME/.dotfiles/config/gammastep.conf $HOME/.config/gammastep.conf
        # Local
        ln -snf $HOME/.dotfiles/local/share/konsole/ $HOME/.local/share/konsole
        ln -snf $HOME/.dotfiles/local/share/color-schemes/ $HOME/.local/share/color-schemes
        # Fonts
        ln -snf $HOME/.dotfiles/fonts/ $HOME/.fonts
      '';
  };
}
