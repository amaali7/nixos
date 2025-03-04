{ lib, pkgs, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.apps.emacs.config.doom;
in {
  options.amaali7.apps.emacs.config.doom = {
    enable = mkEnableOption "Doom Emacs";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ispell
        pandoc
        fira-sans
        graphviz
        markdownlint-cli2
        proselint
        multimarkdown
        coreutils-prefixed
      ];
      activation.linkDoomEmacs =
        config.lib.dag.entryAfter [ "writeBoundary" ] ''
          # Config
          function doom_init_git {
            ${pkgs.git}/bin/git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.config/emacs
            $HOME/.config/emacs/bin/doom install
          }
          ln -snf $HOME/.dotfiles/doom $HOME/.config/doom
          if [ -f $HOME/.config/emacs/ ]; then
              if [ ! -f $HOME/.config/emacs/.doomrc ]; then
                  mv $HOME/.config/emacs $HOME/.config/emacs-old-by-hm
                  doom_init_git
              fi
          else
              doom_init_git
          fi
        '';
    };
  };
}
