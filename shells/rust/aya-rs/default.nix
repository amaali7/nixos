{ pkgs, mkShell, ... }:
let
  aya_run = pkgs.writeShellScriptBin "aya-run" ''
    RUST_LOG=info cargo run --config 'target."cfg(all())".runner="doas "' -- \
      --iface $1'';
in mkShell {
  # The Nix packages provided in the environment
  packages = with pkgs; [
    aya_run
    bpftools
    inetutils
    bpf-linker
    libllvm
    llvmPackages.stdenv
    llvmPackages.llvm
    llvmPackages.llvm.dev
    linux.nativeBuildInputs
  ];

  RUST_LOG = "info";
  RUST_BACKTRACE = 1;
  LIBCLANG_PATH = "${pkgs.lib.makeLibraryPath (with pkgs; [
    libllvm
    libclang
    llvmPackages.llvm
    linux.nativeBuildInputs
  ])}";
  shellHook = ''
    # Required
    echo "Welcome to nix Aya Rust Shell"
  '';
}
