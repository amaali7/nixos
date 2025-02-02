{ lib, pkgs, config, osConfig ? { }, format ? "unknown", namespace, ... }:

with lib.${namespace}; {
  amaali7 = {
    user = {
      enable = true;
      name = "ai3wm";
    };
    apps = {
      # hyprland = enabled;
      i3status = enabled;
    };
    cli-apps = {
      home-manager = enabled;
      # nixvim = enabled;
    };
  };
}
