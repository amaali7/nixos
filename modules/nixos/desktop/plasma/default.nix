{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.desktop.plasma;
in {
  options.amaali7.desktop.plasma = with types; {
    enable = mkBoolOpt false "Whether or not to enable plasma.";
  };

  config = mkIf cfg.enable {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    environment.systemPackages = with pkgs; [ kdePackages.krohnkite ];
    systemd.user.services = {
      plasma-run-with-systemd = {
        description = "Run KDE Plasma via systemd";
        wantedBy = [ "basic.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          env KDEWM=${pkgs.i3-gaps}/usr/bin/i3 ${pkgs.kdePackages.plasma-workspace}/usr/bin/startplasma-x11
        '';
      };
    };
  };
}
