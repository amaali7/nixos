{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.suites.networking;
in {
  options.amaali7.suites.networking = with types; {
    enable = mkBoolOpt false
      "Whether or not to enable common networking configuration.";
  };

  config = mkIf cfg.enable {
    networking = {
      interfaces = {
        "vnet0" = {
          virtual = true;
          ipv4.addresses = [{
            address = "10.10.2.1";
            prefixLength = 24;
          }];
        };
        "vnet1" = {
          virtual = true;
          ipv4.addresses = [{
            address = "10.10.3.1";
            prefixLength = 24;
          }];
        };

      };
    };
  };
}
