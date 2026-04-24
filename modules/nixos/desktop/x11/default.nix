{ options, config, lib, pkgs, inputs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.x11;
in {
  options.amaali7.desktop.x11 = with types; {
    enable = mkBoolOpt false "Whether or not to enable x11.";
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/libexec" ];
    environment.systemPackages = with pkgs; [
      ghostty
      nitrogen
      gnome-disk-utility
      conky
      xdot
      impala
      plantuml
      graphviz
      arandr
      inputs.wiremix.packages.${pkgs.system}.wiremix
    ];
    qt.platformTheme = "qt6ct";
    # QT
    hardware.graphics = {
      enable32Bit = true;
      enable = true;
    };
  };
}
