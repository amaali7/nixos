{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.environment;
in {
  options.amaali7.environment = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables = {
        LD_LIBRARY_PATH = lib.mkDefault "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.openssl}/lib";
      };
    };
  };
}
