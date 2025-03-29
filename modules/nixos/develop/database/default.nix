{ config, lib, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.develop.database;
in {
  options.amaali7.develop.database = with types; {
    enable = mkBoolOpt false "Whether or not to enable c_cpp.";
  };

  config = mkIf cfg.enable {
    amaali7 = {
      # apps = { mariadb = enabled; };
    };
  };
}
