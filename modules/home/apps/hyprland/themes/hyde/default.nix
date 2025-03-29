{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.apps.hyprland.themes.hyde;
in {
  options.amaali7.apps.hyprland.themes.hyde = {
    enable = mkEnableOption "Hyprland Themes";
  };

  config = mkIf cfg.enable {
    amaali7 = { apps = { hyprland.extra.plasma = enabled; }; };
    home = {
      packages = with pkgs; [
        # --------------------------------------------------- // Applications
        firefox # browser
        kitty # terminal
        kdePackages.dolphin # kde file manager
        ark # kde file archiver
        vim # terminal text editor
        vscode # ide text editor
        discord # chat client
        webcord # discord client
        vesktop # discord client

        # --------------------------------------------------- // Dependencies

        # System & Desktop Integration
        polkit_gnome # authentication agent for privilege escalation
        dbus # inter-process communication daemon
        upower # power management/battery status daemon
        mesa # OpenGL implementation and GPU drivers
        dconf # configuration storage system
        home-manager # user environment manager

        # XDG
        xdg-utils # Collection of XDG desktop integration tools

        # TODO: move to qt6, currently bugs waybar and any qt6 apps
        # Qt6/KDE Components
        kdePackages.qtimageformats # Additional image format plugins for Qt6
        kdePackages.ffmpegthumbs # FFmpeg-based video thumbnails for Qt6
        kdePackages.kde-cli-tools # KDE command line tools
        kdePackages.kdegraphics-thumbnailers # KDE graphics file thumbnails
        kdePackages.kimageformats # Additional image format plugins for KDE
        kdePackages.qtimageformats # imageformats for Qt6
        kdePackages.qtwayland # Qt6 Wayland integration
        kdePackages.qtsvg # SVG support for Qt6
        kdePackages.qtbase # Qt6 base libraries
        kdePackages.kio # KDE Input/Output framework
        kdePackages.kio-extras # Additional KIO protocols and file systems
        kdePackages.kwayland # KDE Wayland integration library
        kdePackages.qt5compat # Qt5 compatibility layer for Qt6
        kdePackages.qtstyleplugin-kvantum # Qt6 Kvantum style plugin
        kdePackages.qt6ct # Qt6 configuration tool
        kdePackages.qt6gtk2 # GTK2-style widgets for Qt6

        # Utilities & Tools
        parallel # Shell tool for executing jobs in parallel
        jq # Command-line JSON processor
        imagemagick # Image manipulation tools
        resvg # SVG rendering library and tools
        libnotify # Desktop notification library
        emote # GTK3-based emoji picker
        flatpak # Universal application deployment system
        envsubst # Environment variable substitution utility
        killall # Process termination utility
        wl-clipboard # Wayland clipboard utilities
        gnumake # Build automation tool

        # Hyprland Specific
        hyprcursor # Cursor theme engine for Hyprland
        hyprutils # Utility tools for Hyprland

        # Fonts & Theming
        # fonts # Hyde font collection

        # TODO: build python-pyamdgpuinfo from https://github.com/mark9064/pyamdgpuinfo
        # python-pyamdgpuinfo # for amd gpu info

        # --------------------------------------------------- // Display Manager
        wayland # for wayland support
        egl-wayland # for wayland support
        xwayland # for x11 support

        # --------------------------------------------------- // Music
        cava # audio visualizer

        # --------------------------------------------------- // Shell
        eza # file lister for zsh
        oh-my-zsh # plugin manager for zsh
        zsh-powerlevel10k # theme for zsh
        starship # customizable shell prompt
        fastfetch # system information fetch tool
        git # distributed version control system
        fzf # command line fuzzy finder
        comma # package runner

        # --------------------------------------------------- // System
        pipewire # audio/video server
        wireplumber # pipewire session manager
        pavucontrol # pulseaudio volume control
        pamixer # pulseaudio cli mixer
        networkmanager # network manager
        networkmanagerapplet # network manager system tray utility
        bluez # bluetooth protocol stack
        bluez-tools # bluetooth utility cli
        blueman # bluetooth manager gui
        brightnessctl # screen brightness control
        udiskie # manage removable media
        ntfs3g # ntfs support
        exfat # exFAT support
        swayidle # sway idle management
        playerctl # media player cli
        gobject-introspection # for python packages
        (python3.withPackages (ps: with ps; [ pygobject3 ]))
        trash-cli # cli to manage trash files
        libinput-gestures # actions touchpad gestures using libinput
        libinput # libinput library
        gnomeExtensions.window-gestures # gui for libinput-gestures
        lm_sensors # system sensors
        pciutils # pci utils

        # --------------------------------------------------- // Theming
        nwg-look # gtk configuration tool
        libsForQt5.qt5ct # qt5 configuration tool
        kdePackages.qt6ct # qt6 configuration tool
        libsForQt5.qtstyleplugin-kvantum # svg based qt6 theme engine
        kdePackages.qtstyleplugin-kvantum # svg based qt5 theme engine
        gtk3 # gtk3
        gtk4 # gtk4
        glib # gtk theme management
        gsettings-desktop-schemas # gsettings schemas
        gnome-settings-daemon # for gnome settings
        desktop-file-utils # for updating desktop database
        hicolor-icon-theme # Base fallback icon theme
        adwaita-icon-theme # Standard GNOME icons, excellent fallback
        libsForQt5.breeze-icons # KDE's icon set, good for Qt apps
        dconf-editor # dconf editor
        gnome-tweaks # gnome tweaks

        # --------------------------------------------------- // Window Manager
        dunst # notification daemon
        rofi-wayland # application launcher
        waybar # system bar
        swww # wallpaper
        swaylock # lock screen
        swaylock-fancy # lock screen
        wlogout # logout menu
        grimblast # screenshot tool
        hyprpicker # color picker
        slurp # region select for screenshot/screenshare
        swappy # screenshot editor
        cliphist # clipboard manager
      ];
      activation.linkMyFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        # Config
        for f in $(cd  $HOME/.dotfiles/HyDE/config/ && ls); do                                                                   ─╯
          ln -snf $HOME/.dotfiles/HyDE/config/$f $HOME/.config/$f
        done

        # Local
        mkdir -p $HOME/.local/bin $HOME/.local/lib/hyde $HOME/.local/share $HOME/.local/state

        # Local/Bin
        for f in $(cd  $HOME/.dotfiles/HyDE/local/bin/ && ls); do                                                                   ─╯
          ln -snf $HOME/.dotfiles/HyDE/local/bin/$f $HOME/.local/bin/$f
        done

        # Local/Lib/hyde
        for f in $(cd  $HOME/.dotfiles/HyDE/local/lib/hyde/ && ls); do                                                                   ─╯
          ln -snf $HOME/.dotfiles/HyDE/local/lib/hyde/$f $HOME/.local/lib/hyde/$f
        done


        # Local/Bin
        for f in $(cd  $HOME/.dotfiles/HyDE/local/bin/ && ls); do                                                                   ─╯
          ln -snf $HOME/.dotfiles/HyDE/local/bin/$f $HOME/.local/bin/$f
        done


        # Local/State
        for f in $(cd  $HOME/.dotfiles/HyDE/local/state/ && ls); do                                                                   ─╯
          ln -snf $HOME/.dotfiles/HyDE/local/state/$f $HOME/.local/state/$f
        done

        # Home
        for f in $(cd $HOME/.dotfiles/HyDE/ && ls -p | grep -v / ); do                                                                   ─╯
          ln -snf $HOME/.dotfiles/HyDE/$f $HOME/.$f
        done

      '';
    };
  };
}
