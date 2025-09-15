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
    home = {
      sessionVariables = {
        # QT_XCB_GL_INTEGRATION = "none"; # kde-connect
        EDITOR = "nvim";
        VISUAL = "neovide";
        # BROWSER = "flatpak run org.mozilla.firefox";
        TERMINAL = "wezterm";
        XCURSOR_THEME = "Qogir";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
      # sessionPath =
      # [ "$HOME/.local/bin" "$HOME/.cargo/bin/" "$HOME/.npm-packages/bin/" ];
    };
  };
}
