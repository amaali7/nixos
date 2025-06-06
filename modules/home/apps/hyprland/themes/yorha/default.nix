{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.apps.hyprland.themes.yorha;
in {
  options.amaali7.apps.hyprland.themes.yorha = {
    enable = mkEnableOption "Hyprland Themes";
  };

  config = mkIf cfg.enable {
    amaali7 = { apps = { hyprland.extra.plasma = enabled; }; };
    home = {
      packages = with pkgs;
        [
          wofi
          foot
          grim
          slurp
          swww
          light
          swaylock-effects
          swayidle
          theme-sh
          xdg-desktop-portal-hyprland
          starship
          imagemagick
          cava
          gnome-bluetooth
          libdbusmenu-gtk3
          wl-clipboard
          inputs.ags.packages.${pkgs.system}.ags
        ] ++ (with pkgs.hyprlandPlugins;
          [
            hyprbars

          ]);
      activation.YoRHa = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        # Config
        for f in $(cd  $HOME/.dotfiles/YoRHa/config/ && ls); do
          ln -snf $HOME/.dotfiles/YoRHa/config/$f $HOME/.config/$f
        done

      '';
    };
  };
}
