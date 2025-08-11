{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.develop.rust-rpi;
in {
  options.amaali7.develop.rust-rpi = with types; {
    enable = mkBoolOpt false "Whether or not to enable rust.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cargo-generate
      # Development
      gcc
      pkg-config
      openssl

      # eBPF tools
      bpftools
      bpf-linker
      libllvm
      zlib
      libelf

      clang
      libclang

      bpftools
      inetutils
      bpf-linker
      libllvm

      zlib
      libelf
      llvmPackages.llvm
      llvmPackages.stdenv
      llvmPackages.llvm
      llvmPackages.llvm.dev
    ];
    # services.udev.packages = with pkgs.amaali7; [ probe-rs-udev-rules ];

  };
}
