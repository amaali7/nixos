{ options, config, pkgs, lib, host ? "", format ? "", inputs ? { }, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.services.tor;

in {
  options.amaali7.services.tor = with types; {
    enable = mkBoolOpt false "Whether or not to configure tor support.";
  };

  config = mkIf cfg.enable { services.tor = { client = enabled; }; };
}
