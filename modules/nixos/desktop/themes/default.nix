{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.themes;
in {
  options.amaali7.desktop.themes = with types; {
    enable = mkBoolOpt false "Whether or not to enable themes.";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables = mkForce { QT_QPA_PLATFORMTHEME = "qtct"; };
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs;
      with pkgs.amaali7; [
        # fonts
        #        (nerdfonts.override {
        #          fonts = [
        #            "FiraCode"
        #            "JetBrainsMono"
        #            "Ubuntu"
        #            "UbuntuMono"
        #            "CascadiaCode"
        #            "FantasqueSansMono"
        #            "FiraCode"
        #            "VictorMono"
        #            "Mononoki"
        #          ];
        #        })
        font-awesome

        # themes
        qogir-theme # gtk
        papirus-icon-theme
        qogir-icon-theme
        whitesur-icon-theme
        colloid-icon-theme
        arc-theme
        gradience
        adw-gtk3
        arc-icon-theme
        material-symbols
        jetbrains-mono
        monoco-nf
        sfmono-nf
        st
      ];
  };
}
