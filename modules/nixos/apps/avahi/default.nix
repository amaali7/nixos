{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.avahi;
in {
  options.amaali7.apps.avahi = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
      extraServiceFiles.ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
  };
}
