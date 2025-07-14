{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.suites.common-slim;
in {
  options.amaali7.suites.common-slim = with types; {
    enable =
      mkBoolOpt false "Whether or not to enable common-slim configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.amaali7.list-iommu ];

    amaali7 = {
      nix = enabled;

      # TODO: Enable this once Attic is configured again.
      # cache.public = enabled;

      tools = {
        git = enabled;
        fup-repl = enabled;
        comma = enabled;
        bottom = enabled;
        direnv = enabled;
      };

      hardware = {
        storage = enabled;
        networking = enabled;
      };

      services = {
        openssh = enabled;
        # tailscale = enabled;
      };

      security = { doas = enabled; };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
