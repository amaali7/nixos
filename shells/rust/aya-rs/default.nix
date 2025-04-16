{ pkgs, mkShell, inputs, ... }:
let
  netns_up = pkgs.writeShellScriptBin "veth-up" ''
    # Create two namespaces (ns1 and ns2)
    ip netns add ns1
    ip netns add ns2

    # Create veth pair (veth-ns1 ↔ veth-ns2)
    ip link add veth-ns1 type veth peer name veth-ns2

    # Move each end to its namespace
    ip link set veth-ns1 netns ns1
    ip link set veth-ns2 netns ns2

    # Configure ns1 side
    ip netns exec ns1 ip addr add 10.0.0.1/24 dev veth-ns1
    ip netns exec ns1 ip link set veth-ns1 up
    ip netns exec ns1 ip link set lo up

    # Configure ns2 side
    ip netns exec ns2 ip addr add 10.0.0.2/24 dev veth-ns2
    ip netns exec ns2 ip link set veth-ns2 up
    ip netns exec ns2 ip link set lo up
  '';
  netns_down = pkgs.writeShellScriptBin "veth-down" ''
    # Delete everything
    ip netns del ns1
    ip netns del ns2  '';

  aya_run = pkgs.writeShellScriptBin "aya-run" ''
    RUST_LOG=info cargo run --config 'target."cfg(all())".runner="doas "' -- \
      --iface &1'';
  aya_p_run = pkgs.writeShellScriptBin "aya-p-run" ''
    RUST_LOG=info cargo run --config 'target."cfg(all())".runner="doas ip netns exec ns1 "' -- \
      --iface veth-ns1'';
in mkShell {
  # The Nix packages provided in the environment
  packages = with pkgs;
    [
      aya_run
      aya_p_run
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
    echo "   -> sudo veth-up "
    echo "   -> sudo veth-down"
    echo "veth is isolated interface for testing"
  '';
}
