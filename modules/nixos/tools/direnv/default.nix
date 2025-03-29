{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.tools.direnv;
in {
  options.amaali7.tools.direnv = with types; {
    enable = mkBoolOpt false "Whether or not to enable direnv.";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv = enabled;
      enableZshIntegration = true;
      enableBashIntegration = true;
      loadInNixShell = true;
      silent = true;
      direnvrcExtra = ''
        echo "                   loaded direnv!                   "
        echo "----------------------------------------------------"
      '';
    };
  };
}
