{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.aria2;
in {
  options.amaali7.apps.aria2 = with types; {
    enable = mkBoolOpt false "Whether or not to enable doukutsu-rs.";
  };

  config = mkIf cfg.enable {
    sops.secrets."aria2-password" = { owner = amaali7.user.name; };
    environment.systemPackages = with pkgs; [ aria2 ];
    services.aria2 = {
      enable = true;
      rpcSecretFile = config.age.secrets."aria2-password".path;
    };
    amaali7.user.extraGroups = [ "aria2" ];

  };
}
