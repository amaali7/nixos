{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.postgres;
in {
  options.amaali7.apps.postgres = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pocketcasts.";
  };

  config = mkIf cfg.enable {
    # services.pgadmin = {
    #   port = 5050;
    #   enable = true;
    #   initialEmail = "amaali1991@gmail.com";
    #   initialPasswordFile = "";
    # };
    environment.systemPackages = with pkgs; [ postgresql dbeaver-bin ];
  };
}
