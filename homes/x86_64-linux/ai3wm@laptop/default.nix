{ lib, pkgs, config, osConfig ? { }, format ? "unknown", ... }:

with lib.amaali7; {
  amaali7 = {
    user = {
      enable = true;
      name = "ai3wm";
    };
    apps = {
      # hyprland = enabled;
    };
    cli-apps = {
      home-manager = enabled;
      # nixvim = enabled;
    };
  };
}
