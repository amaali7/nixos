{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.hyprland;
in {
  options.amaali7.desktop.hyprland = with types; {
    enable = mkBoolOpt false "Whether or not to enable hyprland .";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable32Bit = true;
      enable = true;
    };
    environment.sessionVariables =
      lib.mkForce { QT_QPA_PLATFORMTHEME = "qtct"; };
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
      # qt6Packages.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.konsole
      kdePackages.plasma-workspace
      kdePackages.plasma-desktop
      kdePackages.plasma-activities
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
      inputs.ags.packages.${pkgs.system}.ags
    ] ++( with pkgs.kdePackages;
         [
          qtwayland # Hack? To make everything run on Wayland
          qtsvg # Needed to render SVG icons

          # Frameworks with globally loadable bits
          frameworkintegration # provides Qt plugin
          kauth # provides helper service
          kcoreaddons # provides extra mime type info
          kded # provides helper service
          kfilemetadata # provides Qt plugins
          kguiaddons # provides geo URL handlers
          kiconthemes # provides Qt plugins
          kimageformats # provides Qt plugins
          kio # provides helper service + a bunch of other stuff
          kio-admin # managing files as admin
          kio-extras # stuff for MTP, AFC, etc
          kio-fuse # fuse interface for KIO
          kpackage # provides kpackagetool tool
          kservice # provides kbuildsycoca6 tool
          kunifiedpush # provides a background service and a KCM
          kwallet # provides helper service
          kwallet-pam # provides helper service
          kwalletmanager # provides KCMs and stuff
          plasma-activities # provides plasma-activities-cli tool
          solid # provides solid-hardware6 tool
          phonon-vlc # provides Phonon plugin

          # Core Plasma parts
          kwin
          kscreen
          libkscreen
          kscreenlocker
          kactivitymanagerd
          kde-cli-tools
          kglobalacceld # keyboard shortcut daemon
          kwrited # wall message proxy, not to be confused with kwrite
          baloo # system indexer
          milou # search engine atop baloo
          kdegraphics-thumbnailers # pdf etc thumbnailer
          polkit-kde-agent-1 # polkit auth ui
          plasma-desktop
          plasma-workspace
          drkonqi # crash handler
          kde-inotify-survey # warns the user on low inotifywatch limits

          # Application integration
          libplasma # provides Kirigami platform theme
          plasma-integration # provides Qt platform theme
          kde-gtk-config # syncs KDE settings to GTK

          # Artwork + themes
          breeze
          breeze-icons
          breeze-gtk
          ocean-sound-theme
          plasma-workspace-wallpapers
          pkgs.hicolor-icon-theme # fallback icons
          qqc2-breeze-style
          qqc2-desktop-style

          # misc Plasma extras
          kdeplasma-addons
          pkgs.xdg-user-dirs # recommended upstream

          # Plasma utilities
          kmenuedit
          kinfocenter
          plasma-systemmonitor
          ksystemstats
          libksysguard
          systemsettings
          kcmutils
            plasma-browser-integration
            konsole
            (lib.getBin qttools) # Expose qdbus in PATH
            ark
            elisa
            gwenview
            okular
            kate
            khelpcenter
            dolphin
            baloo-widgets # baloo information in Dolphin
            dolphin-plugins
            spectacle
            ffmpegthumbs
            krdp
            xwaylandvideobridge # exposes Wayland windows to X11 screen capture
         ]);

  };
}
