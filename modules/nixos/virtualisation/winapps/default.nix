{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.virtualisation.winapps;
in {
  options.amaali7.virtualisation.winapps = with types; {
    enable = mkBoolOpt false "Whether or not to enable winapps virtualisation.";

  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.winapps.packages."${system}".winapps
      inputs.winapps.packages."${system}".winapps-launcher
      libguestfs
      freerdp
      libnotify
    ];
    # virtualisation.libvirtd = {
    #   enable = true;
    #   qemu = {
    #     package = pkgs.qemu_kvm;
    #     vhostUserPackages = [ pkgs.virtiofsd ];
    #   };
    #   extraConfig = ''
    #     unix_sock_group = "libvirtd"
    #     unix_sock_rw_perms = "0770"
    #   '';
    # };

    # programs.virt-manager.enable = true;
    # virtualisation.spiceUSBRedirection.enable = true;

    # # virtualisation.libvirtd.onBoot = "start";
    # networking.firewall.trustedInterfaces = [ "virbr0" ];
    # networking.firewall.allowedTCPPorts = [ 3389 ];
    # # Auto-start libvirt default network
    # systemd.services.libvirt-default-network = {
    #   description = "Start libvirt default network";
    #   after = [ "libvirtd.service" ];
    #   wantedBy = [ "multi-user.target" ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #     ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
    #     ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
    #     User = "root";
    #   };
    # };
    # users.groups.libvirtd.members = [ "${config.amaali7.user.name}" ];
    # amaali7 = { user = { extraGroups = [ "libvirtd" ]; }; };
  };
}
