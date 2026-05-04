{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.wine;
in {
  options.amaali7.apps.wine = with types; {
    enable = mkBoolOpt false "Whether or not to enable doukutsu-rs.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        # support both 32-bit and 64-bit applications
        wineWow64Packages.full

      ];
  };
}
