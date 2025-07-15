{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.suites.media;
in {
  options.amaali7.suites.media = with types; {
    enable = mkBoolOpt false "Whether or not to enable media configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ yt-dlp ];
    amaali7 = {
      apps = {
        mousai = enabled;
        freetube = enabled;
        webtorrent = enabled;
      };
    };
  };
}
