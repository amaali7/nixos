{ options, config, pkgs, lib, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.system.ebpf;
in {
  options.amaali7.system.ebpf = with types; {
    enable = mkBoolOpt false "Whether or not to enable booting.";
  };

  config = mkIf cfg.enable {

    # Required kernel configuration for aya-rs
    boot.kernelParams = [ "net.core.bpf_jit_enable=1" ];

    # Additional packages you might need
    environment.systemPackages = with pkgs; [
      iproute2 # for network namespace management
      ethtool # for interface configuration
      tcpdump # for packet inspection
      wireshark # optional - for detailed packet analysis
    ];

    # Enable BPF JIT compiler (improves performance)
    boot.kernel.sysctl."net.core.bpf_jit_enable" = 1;
  };
}
