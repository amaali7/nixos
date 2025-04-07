{ pkgs, mkShell, inputs, ... }:
let
  netns_up = pkgs.writeShellScriptBin "dnet-up" ''
    # Load the dummy kernel module (if not loaded)
    modprobe dummy

    # Create first dummy interface (dummy0)
     ip link add dummy0 type dummy

    # Create second dummy interface (dummy1)
     ip link add dummy1 type dummy

    # Assign IP to dummy0
     ip addr add 192.168.1.1/24 dev dummy0

    # Assign IP to dummy1
     ip addr add 192.168.1.2/24 dev dummy1

     ip link set dummy0 up
     ip link set dummy1 up
  '';
  netns_down = pkgs.writeShellScriptBin "dnet-down" ''
    # Delete namespaces (automatically removes interfaces)
     ip link del dummy0
     ip link del dummy1  '';
  aya_run = pkgs.writeShellScriptBin "aya-run" ''
    RUST_LOG=info cargo run --config 'target."cfg(all())".runner="doas "' -- \
      --iface $1'';
in mkShell {
  # The Nix packages provided in the environment
  packages = with pkgs;
    [
      aya_run
      netns_up
      netns_down
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
    echo "CMD:"
    echo "   -> aya-run"
    echo "   -> sudo dnet-up "
    echo "   -> sudo dnet-down"
    echo "dnet is dummy interface for testing"
  '';
}
