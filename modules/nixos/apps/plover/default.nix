{ options, config, lib, pkgs, inputs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.obsidian;
in {
  options.amaali7.apps.plover = with types; {
    enable = mkBoolOpt false "Whether or not to enable plover.";
  };

  config = mkIf cfg.enable {
    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
    amaali7.user.extraGroups = [ "dialout" "input" ];
    environment.systemPackages =
      [ inputs.plover-flake.packages.${pkgs.system}.plover-full ];
  };
}
