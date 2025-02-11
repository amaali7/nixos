{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

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
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
        inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus
        inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
        inputs.hyprland-plugins.packages.${pkgs.system}.xtra-dispatchers
      ];

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
  };
}
