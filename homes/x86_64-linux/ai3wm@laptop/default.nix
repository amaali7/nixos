{ lib, pkgs, config, osConfig ? { }, format ? "unknown", namespace, ... }:

with lib.${namespace}; {
  amaali7 = {
    user = {
      enable = true;
      name = "ai3wm";
    };
    apps = {
      # niri = enabled;
      hyprland = enabled;
      emacs = enabled;
    };
    cli-apps = {
      home-manager = enabled;
      neovim = enabled;
      nushell = enabled;
    };
  };
}
