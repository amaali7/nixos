{ lib, config, inputs, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.shell.nushell;
in {
  options.amaali7.shell.nushell = { enable = mkEnableOption "enable nushell"; };

  config = mkIf cfg.enable {
    amaali7 = { user.extraOptions = { shell = pkgs.nushell; }; };
    # environment.interactiveShellInit = "$HOME/export-esp.sh";
    users.defaultUserShell = pkgs.nushell;
    environment.shells = with pkgs; [ nushell ];
  };
}
