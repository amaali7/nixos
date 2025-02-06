{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.themes;
in {
  options.amaali7.desktop.themes = with types; {
    enable = mkBoolOpt false "Whether or not to enable themes.";
  };

  config = mkIf cfg.enable {
    # environment.sessionVariables = {
    #   QT_QPA_PLATFORMTHEME = "gtk2";
    # };

    environment.systemPackages = with pkgs;
      with pkgs.amaali7; [
        # fonts
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
            "Ubuntu"
            "UbuntuMono"
            "CascadiaCode"
            "FantasqueSansMono"
            "FiraCode"
            "VictorMono"
            "Mononoki"
          ];
        })
        acyl
        font-awesome

        # themes
        libsForQt5.qtstyleplugins
        qogir-theme # gtk
        papirus-icon-theme
        qogir-icon-theme
        whitesur-icon-theme
        colloid-icon-theme
        arc-theme
        gradience
        adw-gtk3
        arc-icon-theme
        dark-decay-gtk
        decayce-gtk
        material-symbols
        jetbrains-mono
        monoco-nf
        sfmono-nf
        st
      ];
  };
}
