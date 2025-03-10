{ pkgs, mkShell, inputs, ... }:
let
  aya_run = pkgs.writeShellScriptBin "aya-run" ''
    RUST_LOG=info cargo run --config 'target."cfg(all())".runner="doas "' -- \
      --iface $1'';
in mkShell {
  # The Nix packages provided in the environment
  packages = with pkgs;
    [
      aya_run
      bpftools
      inetutils
      bpf-linker
      libllvm

      linux.nativeBuildInputs
      zlib
      ncurses
      libxml2
      libelf
    ] ++ (with inputs.unstable.legacyPackages.${pkgs.system}; [
      llvmPackages_20.llvm
      llvmPackages_20.stdenv
      llvmPackages_20.llvm
      llvmPackages_20.llvm.dev
    ]);

  RUST_LOG = "info";
  RUST_BACKTRACE = 1;
  LIBCLANG_PATH = "${pkgs.lib.makeLibraryPath (with pkgs; [
    libllvm
    libclang
    inputs.unstable.legacyPackages.${pkgs.system}.llvmPackages_20.llvm
    libelf
  ])}";
  shellHook = ''
    # Required
    echo "Welcome to nix Aya Rust Shell"
  '';
}
