{ options, config, pkgs, lib, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.hardware.video;
in {
  options.amaali7.hardware.video = with types; {
    enable = mkBoolOpt false "Whether or not to enable networking support";
    hosts =
      mkOpt attrs { } (mdDoc "An attribute set to merge with `video.hosts`");
  };

  config = mkIf cfg.enable {
    hardware = {
      # smooth backlight control
      brillo.enable = true;

      graphics = {
        extraPackages32 = with pkgs.pkgsi686Linux; [
          libva-vdpau-driver
          libvdpau-va-gl
        ];
        extraPackages = with pkgs; [ libva-vdpau-driver libvdpau-va-gl ];
      };

      opentabletdriver.enable = true;

      xpadneo.enable = true;
    };
  };
}
