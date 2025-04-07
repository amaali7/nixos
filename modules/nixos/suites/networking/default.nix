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
          ipv6.addresses = [{
            address = "2a01:4f8:1c1b:16d0::1";
            prefixLength = 64;
          }];
          ipv4.addresses = [{
            address = "192.168.2.2";
            prefixLength = 24;
          }];
        };
        "vnet1" = {
          virtual = true;
          ipv6.addresses = [{
            address = "2a01:4f8:1c1b:16d1::1";
            prefixLength = 64;
          }];
          ipv4.addresses = [{
            address = "192.168.3.2";
            prefixLength = 24;
          }];
        };

      };
    };
  };
}
