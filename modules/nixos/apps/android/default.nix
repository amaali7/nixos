{ options, inputs, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.android;
in {
  options.amaali7.apps.android = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    # services.udev.packages = [ pkgs.android-udev-rules ];
    environment.systemPackages = with pkgs; [ android-tools ];
  };
}
