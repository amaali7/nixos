{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.xournalpp;
in {
  options.amaali7.apps.xournalpp = with types; {
    enable = mkBoolOpt false "Whether or not to enable xournalpp.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ poppler-utils xournalpp ];
  };
}
