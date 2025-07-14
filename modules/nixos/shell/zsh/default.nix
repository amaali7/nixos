{ lib, config, inputs, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.shell.zsh;
in {
  options.amaali7.shell.zsh = { enable = mkEnableOption "enable zsh"; };

  config = mkIf cfg.enable {
    amaali7 = {
      home = {
        extraOptions = {
          home = {
            packages = with pkgs; [ zoxide ];
            sessionVariables = { SHELL = "${pkgs.zsh}/bin/zsh"; };
            sessionPath = [
              "$HOME/.local/bin"
              "$HOME/.cargo/bin/"
              "$HOME/.npm-packages/bin/"
            ];
          };
        };
      };
      user.extraOptions = { shell = pkgs.zsh; };
    };
    # environment.interactiveShellInit = "$HOME/export-esp.sh";
    users.defaultUserShell = pkgs.zsh;
    environment.shells = with pkgs; [ zsh ];
    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "${pkgs.lsd}/bin/lsd -l";
        ls = "${pkgs.lsd}/bin/lsd";
        lzg = "lazygit";
      };
      histSize = 10000;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "sudo" "terraform" "systemadmin" "vi-mode" ];
      };
    };

  };
}
