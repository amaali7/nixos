{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.apps.quickshell;
in {
  options.amaali7.apps.quickshell = {
    enable = mkEnableOption "QuickShell Themes";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # Quickshell stuff
        qt6Packages.qt5compat
        kdePackages.qtbase
        kdePackages.qtdeclarative
        libsForQt5.qt5.qtgraphicaleffects
        (inputs.quickshell.packages.${pkgs.system}.default.override {
          withJemalloc = true;
          withQtSvg = true;
          withWayland = true;
          withX11 = false;
          withPipewire = true;
          withPam = true;
          withHyprland = true;
          withI3 = false;
        })
      ];
      activation.linkQuickShell =
        config.lib.dag.entryAfter [ "writeBoundary" ] ''
          # Config
            ln -snf $HOME/.dotfiles/qml $HOME/.config/quickshell
        '';
    };
  };
}
