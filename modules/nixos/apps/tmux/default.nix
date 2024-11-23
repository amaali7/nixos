{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.tmux;
in {
  options.amaali7.apps.tmux = with types; {
    enable = mkBoolOpt false "Whether or not to enable tmux.";
  };

  config =
    mkIf cfg.enable { environment.systemPackages = with pkgs; [ tmux ]; };
}
