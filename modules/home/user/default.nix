{ lib, config, pkgs, osConfig ? { }, ... }:

let
  inherit (lib) types mkIf mkDefault mkMerge;
  inherit (lib.amaali7) mkOpt;

  cfg = config.amaali7.user;
  home-directory = if cfg.name == null then null else "/home/${cfg.name}";
in {
  options.amaali7.user = {
    enable = mkOpt types.bool false "Whether to configure the user account.";
    name = mkOpt (types.nullOr types.str) "ai3wm" "The user account.";

    fullName = mkOpt types.str "Abdallah Ali" "The full name of the user.";
    email = mkOpt types.str "amaali1991@gmail.com" "The email of the user.";

    home = mkOpt (types.nullOr types.str) home-directory
      "The user's home directory.";
  };

  config = mkIf cfg.enable (mkMerge [{
    snowfallorg.user = {
      enable = true;
      name = "name";
      # home = "/home/ai3wm/";
    };

    assertions = [
      {
        assertion = cfg.name != null;
        message = "amaali7.user.name must be set";
      }
      {
        assertion = cfg.home != null;
        message = "amaali7.user.home must be set";
      }
    ];

    home = {
      username = mkDefault cfg.name;
      homeDirectory = mkDefault cfg.home;
    };
  }]);
}
