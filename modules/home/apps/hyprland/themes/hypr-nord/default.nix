{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.hyprland.themes.hypr-nord;
in {
  options.amaali7.apps.hyprland.themes.hypr-nord = {
    enable = mkEnableOption "Hyprland Themes";
  };

  config = mkIf cfg.enable {
    # amaali7 = { apps = { hyprland.extra.plasma = enabled; }; };
    # Required for GNOME/GTK apps

    # Set Nord as default
    gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      iconTheme = {
        name = "Nordic-Folder";
        package = pkgs.nordic;
      };
      cursorTheme = {
        name = "Nordic-cursors";
        package = pkgs.nordic;
      };
    };

    # Optional: Force dark mode
    qt = {
      enable = true;
      platformTheme.name = "gtk"; # Inherit GTK theme
      # OR use Kvantum for Nord
      style = {
        name = "kvantum";
        package = pkgs.libsForQt5.qtstyleplugin-kvantum;
      };
    };
    programs.kitty = {
      enable = true;
      themeFile = "Nord";
      extraConfig = ''
        font_size 16.0
        map ctrl+v paste_from_clipboard
        copy_on_select yes

        tab_bar_min_tabs            1
        tab_bar_edge                bottom
        tab_bar_style               powerline
        tab_powerline_style         slanted
        tab_title_template          {title}{' :{}:'.format(num_windows) if num_windows > 1 else '''}
        window_padding_width	      3

      '';
      settings = {
        foreground = "#D8DEE9";
        background = "#2E3440";
        selection_foreground = "#D8DEE9";
        selection_background = "#4C566A";
        url_color = "#88C0D0";
        cursor = "#81A1C1";

        # Nord color palette
        color0 = "#3B4252"; # Black
        color1 = "#BF616A"; # Red
        color2 = "#A3BE8C"; # Green
        color3 = "#EBCB8B"; # Yellow
        color4 = "#81A1C1"; # Blue
        color5 = "#B48EAD"; # Magenta
        color6 = "#88C0D0"; # Cyan
        color7 = "#E5E9F0"; # White
        color8 = "#4C566A"; # Bright Black
        color9 = "#BF616A"; # Bright Red
        color10 = "#A3BE8C"; # Bright Green
        color11 = "#EBCB8B"; # Bright Yellow
        color12 = "#81A1C1"; # Bright Blue
        color13 = "#B48EAD"; # Bright Magenta
        color14 = "#8FBCBB"; # Bright Cyan
        color15 = "#ECEFF4"; # Bright White
      };
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
      activation.linkHyprNordFiles =
        config.lib.dag.entryAfter [ "writeBoundary" ] ''
          # Config
          for f in $(cd  $HOME/.dotfiles/nord-hypr-way/config/ && ls); do
            ln -snf $HOME/.dotfiles/nord-hypr-way/config/$f $HOME/.config/$f
          done
          # Fonts
          for f in $(cd  $HOME/.dotfiles/nord-hypr-way/assets/fonts/ && ls); do
            ln -snf $HOME/.dotfiles/nord-hypr-way/assets/fonts/$f $HOME/.fonts/$f
          done
          # Fonts
          for f in $(cd  $HOME/.dotfiles/nord-hypr-way/assets/images/ && ls); do
            ln -snf $HOME/.dotfiles/nord-hypr-way/assets/images/$f $HOME/Pictures/nord/$f
          done
        '';
    };
  };
}
