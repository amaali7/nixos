{ lib, config, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.cli-apps.ghostty;
in {
  options.amaali7.cli-apps.ghostty = { enable = mkEnableOption "ghostty"; };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ ghostty ]; };
}
