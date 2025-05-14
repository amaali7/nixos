{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.common-tiling;
in {
  options.amaali7.desktop.common-tiling = with types; {
    enable = mkBoolOpt false "Whether or not to enable common-tiling.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      with pkgs.amaali7; [
        arandr
        lxappearance
        gvfs
        dex
        redshift
        # picom
        bat
        eza
        light
        playerctl
        maim
        jq
        brightnessctl
        upower
        inotify-tools
        acpid
        wmctrl
        nitrogen
        xdotool
        xclip
        scrot
        acpi
        dunst
        # Rust Base
        yazi
        lsd
      ];
  };
}
