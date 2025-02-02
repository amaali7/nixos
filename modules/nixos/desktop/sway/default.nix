{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.sway;
in {
  options.amaali7.desktop.sway = with types; {
    enable = mkBoolOpt false "Whether or not to enable sway.";
  };

  config = mkIf cfg.enable {
    services.displayManager.sessionPackages = [
      (pkgs.swayfx.overrideAttrs
        (old: { passthru.providedSessions = [ "sway" ]; }))
    ];
    programs.sway = {
      enable = true;
      package = pkgs.swayfx;
      # package = (pkgs.swayfx.overrideAttrs
      #   (old: { passthru.providedSessions = [ "sway" ]; }));
      extraPackages = with pkgs;
        with pkgs.amaali7; [
          swayfx
          swaylock
          swayidle
          foot
          waybar
          autotiling-rs
          light
          ueberzugpp
        ];
      wrapperFeatures.gtk = true; # so that gtk works properly
      extraSessionCommands = ''
         export SDL_VIDEODRIVER=wayland
         export QT_QPA_PLATFORM=wayland
         export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
         export _JAVA_AWT_WM_NONREPARENTING=1
        # export MOZ_ENABLE_WAYLAND=1
      '';
    };
    programs.waybar.enable = true;
    amaali7 = { desktop.wayland = enabled; };
  };
}
