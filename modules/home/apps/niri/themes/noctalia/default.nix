{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;
  user = config.amaali7.user;
  homeD = if user.name == null then null else "/home/${user.name}";

  cfg = config.amaali7.apps.niri.themes.noctalia;
in {
  options.amaali7.apps.niri.themes.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia-shell = { enable = true; };
    programs = {
      niri = {
        enable = true;
        settings = {
          outputs = {
            "eDP-1" = {
              mode = {
                height = 1080;
                width = 1920;
                refresh = 60.006;
              };
              position = {
                x = 0;
                y = 0;
              };
            };
            "HDMI-A-1" = {
              mode = {
                height = 1200;
                width = 1920;
                refresh = 59.95;
              };
              position = {
                x = 1080;
                y = 0;
              };
              focus-at-startup = true;
            };
          };
          input.keyboard.xkb = {
            layout = "us,ara";
            options = "grp:alt_shift_toggle,ctrl:nocaps";
          };
          prefer-no-csd = true;
          gestures.hot-corners.enable = true;
          spawn-at-startup = [{ command = [ "noctalia-shell" ]; }];
          binds = with config.lib.niri.actions; {
            # ...
            "Mod+Z".action.spawn = [ "zen" ];
            "Mod+Return".action.spawn = [ "kitty" ];
            "Mod+T".action.spawn = [ "thunar" ];
            "Mod+D".action.spawn = [
              "noctalia-shell"
              "ipc"
              "call"
              "launcher"
              "toggle" # ✅
            ];
            # "Mod+L".action.spawn = noctalia "lockScreen toggle";
            # "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
            # "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
            # "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
            # etc
          };
        };
      };
    };
  };
}
