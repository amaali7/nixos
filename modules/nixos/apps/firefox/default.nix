{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let
  cfg = config.amaali7.apps.firefox;
  defaultSettings = {
    "browser.startup.homepage" = "https://google.com";
    "browser.ssb.enabled" = true;
  };
in
{
  options.amaali7.apps.firefox = with types; {
    enable = mkBoolOpt false "Whether or not to enable Firefox.";
    extraConfig =
      mkOpt str "" "Extra configuration for the user profile JS file.";
    userChrome =
      mkOpt str "" "Extra configuration for the user chrome CSS file.";
    settings = mkOpt attrs defaultSettings "Settings to apply to the profile.";
  };

  config = mkIf cfg.enable {
    # amaali7.desktop.addons.firefox-nordic-theme = enabled;
    amaali7.home = {
      extraOptions = {
        programs.firefox = {
          enable = true;

          profiles.${config.amaali7.user.name} = {
            inherit (cfg) extraConfig userChrome settings;
            id = 0;
            name = config.amaali7.user.name;
          };
        };
      };
    };
  };
}
