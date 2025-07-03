{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";
  browser = "${pkgs.zen}/bin/zen";
  terminal = "${pkgs.kitty}/bin/kitty";
  fileManager = "${pkgs.xfce.thunar}/bin/thunar";
  editor = "${pkgs.emacs}/bin/emacs";

  screenshotArea =
    "${pkgs.bash}/bin/bash -c '${pkgs.grim}/bin/grim -g \"\\$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy'";
  screenshotWindow =
    "${pkgs.bash}/bin/bash -c '${pkgs.grim}/bin/grim -g \"\\$(${pkgs.slurp}/bin/slurp -w)\" - | ${pkgs.wl-clipboard}/bin/wl-copy'";
  screenshotOutput =
    "${pkgs.bash}/bin/bash -c '${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy'";
  brightnessScript = pkgs.writeShellScriptBin "brightness" ''
    BUS=10
    STEP=5
    MIN=0
    MAX=100
    OSD_FILE="/tmp/brightness_osd_level"

    current=$(ddcutil --bus=$BUS getvcp 10 | grep -oP "current value\\s*=\\s*\\K[0-9]+")
    new=$current

    if [[ "$1" == "up" ]]; then
      new=$((current + STEP))
      (( new > MAX )) && new=$MAX
    elif [[ "$1" == "down" ]]; then
      new=$((current - STEP))
      (( new < MIN )) && new=$MIN
    else
      exit 1
    fi

    ddcutil --bus=$BUS setvcp 10 "$new"
    echo "$new" > "$OSD_FILE"
  '';

  cfg = config.amaali7.apps.niri;
in {
  options.amaali7.apps.niri = { enable = mkEnableOption "niri"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Desktop
      hyprlock
      nwg-look
      walker
      brightnessScript
      # Niri
      xwayland-satellite
      grim
      slurp
      wl-clipboard
    ];
    home = {
      programs.niri = {
        enable = true;
        package = pkgs.niri;
        settings = {
          # Autostrt
          spawn-at-startup = [
            { command = [ "systemctl" "--user" "start" "hyprpolkitagent" ]; }
            { command = [ "arrpc" ]; }
            { command = [ "xwayland-satellite" ]; }
            { command = [ "qs" ]; }
            {
              command = [
                "${pkgs.swaybg}/bin/swaybg"
                "-o"
                "eDP-1"
                "-i"
                "$HOME/Pictures/wallpapers/clouds.png"
                "-m"
                "fill"
              ];
            }
            {
              command = [
                "${pkgs.swaybg}/bin/swaybg"
                "-o"
                "HDMI-A-1"
                "-i"
                "$HOME/Pictures/wallpapers/clouds.png"
                "-m"
                "fill"
              ];
            }
            #{ command = ["sh" "-c" "swww-daemon & swww img /home/lysec/nixos/wallpapers/cloud.png"]; }
          ];

          # Bindings
          binds = with config.lib.niri.actions;
            let
              pactl = "${pkgs.pulseaudio}/bin/pactl";

              volume-up =
                spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "+5%" ];
              volume-down =
                spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "-5%" ];
            in {
              "xf86audioraisevolume".action = volume-up;
              "xf86audiolowervolume".action = volume-down;

              "control+super+xf86audioraisevolume".action =
                spawn "brightness" "up";
              "control+super+xf86audiolowervolume".action =
                spawn "brightness" "down";

              "super+q".action = close-window;
              "super+b".action = spawn apps.browser;
              "super+Return".action = spawn apps.terminal;
              "super+Control+Return".action = spawn apps.editor;
              "super+E".action = spawn apps.fileManager;

              "super+f".action = fullscreen-window;
              "super+t".action = toggle-window-floating;

              "control+shift+1".action = screenshot;
              "control+shift+2".action =
                screenshot-window { write-to-disk = true; };

              "super+Left".action = focus-column-left;
              "super+Right".action = focus-column-right;
              "super+Down".action = focus-workspace-down;
              "super+Up".action = focus-workspace-up;

              "super+Shift+Left".action = move-column-left;
              "super+Shift+Right".action = move-column-right;
              "super+Shift+Down".action = move-column-to-workspace-down;
              "super+Shift+Up".action = move-column-to-workspace-up;

              "super+1".action = focus-workspace "browser";
              "super+2".action = focus-workspace "vesktop";
            };
          # Rules Settings
          layer-rules = [{
            matches = [{ namespace = "^swww-daemon$"; }];
            place-within-backdrop = true;
          }];
          window-rules = [
            {
              matches = [{ app-id = "firefox"; }];
              open-on-workspace = "browser";
              geometry-corner-radius = {
                top-left = 20.0;
                top-right = 20.0;
                bottom-left = 20.0;
                bottom-right = 20.0;
              };
              clip-to-geometry = true;
            }

            # Vesktop with rounded corners
            {
              matches = [{ app-id = "vesktop"; }];
              open-on-workspace = "vesktop";
              geometry-corner-radius = {
                top-left = 20.0;
                top-right = 20.0;
                bottom-left = 20.0;
                bottom-right = 20.0;
              };
              clip-to-geometry = true;
            }

            # Default rule for all other windows with rounded corners
            {
              matches =
                [ { } ]; # Matches all windows not matched by above rules
              geometry-corner-radius = {
                top-left = 20.0;
                top-right = 20.0;
                bottom-left = 20.0;
                bottom-right = 20.0;
              };
              clip-to-geometry = true;
            }
          ];
          # General Settings
          workspaces = {
            "browser" = { };
            "vesktop" = { };
          };

          prefer-no-csd = true;

          hotkey-overlay = { skip-at-startup = true; };

          layout = {

            focus-ring = {
              enable = true;
              width = 3;
              active = { color = "#c488ec"; };
              inactive = { color = "#505050"; };
            };

            gaps = 6;

            struts = {
              left = 20;
              right = 20;
              top = 20;
              bottom = 20;
            };
          };

          input = {
            keyboard.xkb.layout = "de";
            touchpad = {
              click-method = "button-areas";
              dwt = true;
              dwtp = true;
              natural-scroll = true;
              scroll-method = "two-finger";
              tap = true;
              tap-button-map = "left-right-middle";
              middle-emulation = true;
              accel-profile = "adaptive";
            };
            focus-follows-mouse.enable = true;
            warp-mouse-to-focus.enable = false;
          };

          outputs = {
            "DP-1" = {
              mode = {
                width = 2560;
                height = 1440;
                refresh = 359.979;
              };
              scale = 1.0;
              position = {
                x = 0;
                y = 0;
              };
            };
          };

          cursor = {
            size = 20;
            theme = "Adwaita";
          };

          environment = {
            CLUTTER_BACKEND = "wayland";
            GDK_BACKEND = "wayland,x11";
            MOZ_ENABLE_WAYLAND = "1";
            NIXOS_OZONE_WL = "1";
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            ELECTRON_ENABLE_HARDWARE_ACCELERATION = "1";

            XDG_SESSION_TYPE = "wayland";
            XDG_CURRENT_DESKTOP = "niri";
            DISPLAY = ":0";
          };
        };
      };
    };
  };
}
