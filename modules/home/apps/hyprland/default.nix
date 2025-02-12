{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.hyprland;
in {
  options.amaali7.apps.hyprland = { enable = mkEnableOption "Hyprland"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
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
      #inputs.ags.packages.${pkgs.system}.agsFull
    ];
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland = enabled;
      # plugins = [
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
      #   inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
      #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      #   inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus
      #   inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      #   inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers
      # ];

      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, ENTER, exec, kitty"
          "$mod, F, exec, firefox"
          ", Print, exec, grimblast copy area"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]) 9));
      };
    };
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
        ln -s $HOME/.dotfiles/config/hypr/ $HOME/.config/hypr
        ln -s $HOME/.dotfiles/config/ags/ $HOME/.config/ags
        ln -s $HOME/.dotfiles/config/easyeffects/ $HOME/.config/easyeffects
        ln -s $HOME/.dotfiles/config/kavntum/ $HOME/.config/kavntum
        ln -s $HOME/.dotfiles/config/qt5ct/ $HOME/.config/qt5ct
        ln -s $HOME/.dotfiles/config/qt6ct/ $HOME/.config/qt6ct
        ln -s $HOME/.dotfiles/config/wafi/ $HOME/.config/wafi
        ln -s $HOME/.dotfiles/config/gammastep.conf $HOME/.config/gammastep.conf
        # Local
        ln -s $HOME/.dotfiles/local/share/konsole/ $HOME/.local/share/konsole
        ln -s $HOME/.dotfiles/local/share/color-schemes/ $HOME/.local/share/color-schemes
        # Fonts
        ln -s $HOME/.dotfiles/fonts/ $HOME/.fonts
      '';
  };
}
