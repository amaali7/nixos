{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.security.sops;
in {
  options.amaali7.security.sops = with types; {
    enable = mkBoolOpt false "Whether to enable  sops.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ age sops ];
    sops = {
      defaultSopsFile = "../../../../secrets/secrets.yaml"; # Adjust path
      defaultSopsFormat = "yaml";
      age.keyFile =
        "/home/${amaali7.user.name}/.config/sops/age/keys.txt"; # Adjust path to your age key
    };

  };
}
