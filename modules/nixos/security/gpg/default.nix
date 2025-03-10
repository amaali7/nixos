{ options, config, pkgs, lib, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.security.gpg;
in {
  options.amaali7.security.gpg = with types; {
    enable = mkBoolOpt false "Whether or not to enable GPG.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cryptsetup
      paperkey
      gnupg
      pinentry-curses
      pinentry-qt
      paperkey
    ];

    programs = {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        enableExtraSocket = true;
        # pinentryFlavor = "gnome3";
      };
    };
  };
}
