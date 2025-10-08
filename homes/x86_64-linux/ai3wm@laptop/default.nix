{ lib, pkgs, config, osConfig ? { }, format ? "unknown", namespace, ... }:

with lib.${namespace}; {
  amaali7 = {
    user = {
      enable = true;
      name = "ai3wm";
    };
    apps = {
      hyprland = enabled;
      emacs = enabled;
    };
    cli-apps = {
      home-manager = enabled;
      nushell = enabled;
    };
  };
}
