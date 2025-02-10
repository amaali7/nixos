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
    environment.systemPackages = with pkgs; [
      kdePackages.krohnkite
      qt6Packages.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
    ];
    systemd.user.services = {
      plasma-kwin_x11 = { enable = false; };
      plasma-i3 = {
        enable = true;
        description = "Launch Plasma with i3";
        before = [ "plasma-workspace.target" ];
        wantedBy = [ "plasma-workspace.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.i3}/usr/bin/i3";
          Restart = "on-failure";
        };
      };
    };
  };
}
