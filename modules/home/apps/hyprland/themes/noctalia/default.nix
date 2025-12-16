{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.hyprland.themes.noctalia;
in {
  options.amaali7.apps.hyprland.themes.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = { enable = true; };
    programs.kitty = {
      enable = true;
      themeFile = "nocatalia";
      extraConfig = ''
        font_size 14.0
        map ctrl+v paste_from_clipboard
        copy_on_select yes

        tab_bar_min_tabs            1
        tab_bar_edge                bottom
        tab_bar_style               powerline
        tab_powerline_style         slanted
        tab_title_template          {title}{' :{}:'.format(num_windows) if num_windows > 1 else '''}
        window_padding_width	      3

      '';
      font = {
        name = "Fira Code";
        size = 16;
      };
    };
    home = {
      packages = with pkgs; [
        # Nord Start
        btop
        cava
        fastfetch
        harlequin
        kitty
        pipes
        brightnessctl
        # posting
        starship
        superfile
        tty-clock
        waybar
        # Nord End
        nordic
        hyprshot
        bc
        nwg-look
        blueman
        # ------
        grim
        slurp
        swww
        fish
        light
        swaylock-effects
        swayidle
        xdg-desktop-portal-hyprland
        starship
        cava
        imagemagick
        gnome-bluetooth
        wl-clipboard
        # ------
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
        # watershot
        hyprland
        hyprland-protocols
        # hyprland-share-picker
        wlprop
        inputs.hyprland-contrib.packages.${pkgs.system}.hyprprop
      ];

      activation.linkHyprNactaliaFiles =
        config.lib.dag.entryAfter [ "writeBoundary" ] ''
          # Config
          ln -snf $HOME/.dotfiles/nord-hypr-way/config/hypr $HOME/.config/hypr
        '';
    };
  };
}
