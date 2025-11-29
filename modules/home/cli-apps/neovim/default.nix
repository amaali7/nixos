{ lib, config, inputs, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.cli-apps.neovim;
in {
  options.amaali7.cli-apps.neovim = { enable = mkEnableOption "neovim"; };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      # defaultEditor = true;
    };
    home.packages = with pkgs; [ neovide ];
  };
}
