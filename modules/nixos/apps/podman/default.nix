{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.podman;
in {
  options.amaali7.apps.podman = with types; {
    enable = mkBoolOpt false "Whether or not to enable podman.";
  };

  config = mkIf cfg.enable {
    boot.binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true; # required to work with podman
    };
    # Enable common container config files in /etc/containers
    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers = {
      container-name = {
        image = "container-image";
        autoStart = true;
        ports = [ "127.0.0.1:1234:1234" ];
      };
    };
    xdg.configFile."containers/registries.conf".text = ''
      [registries.search]
      registries = ['docker.io']
    '';
    environment.systemPackages = with pkgs; [
      podman
      podman-tui
      podman-compose
      podman-desktop
    ];

    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
