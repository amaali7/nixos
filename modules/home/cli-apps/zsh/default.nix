{ lib, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.cli-apps.zsh;
in {
  options.amaali7.cli-apps.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.activation.linkZsh = config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ln -snf $HOME/.dotfiles/zshrc $HOME/.zshrc
    '';
  };
}
