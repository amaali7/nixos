{ pkgs, mkShell, inputs, ... }:
let
  netns_up = pkgs.writeShellScriptBin "inet-up" ''
    # Create namespaces
    doas ip netns add red
    doas ip netns add blue

    # Create veth pair (veth-red <--> veth-blue)
    doas ip link add veth-red type veth peer name veth-blue

    # Move interfaces to respective namespaces
    doas ip link set veth-red netns red
    doas ip link set veth-blue netns blue

    # Assign IPs (different subnets for isolation)
    doas ip -n red addr add 192.168.1.1/24 dev veth-red
    doas ip -n blue addr add 192.168.2.1/24 dev veth-blue

    # Bring them up
    ip -n red link set veth-red up
     ip -n blue link set veth-blue up

    # Enable loopback in both namespaces
     ip -n red link set lo up
     ip -n blue link set lo up

    # Ping from red to blue (should fail - no route)
     ip netns exec red ping 192.168.2.1 -c 3

    # Ping from blue to red (should fail)
     ip netns exec blue ping 192.168.1.1 -c 3

  '';
  netns_down = pkgs.writeShellScriptBin "inet-down" ''
    # Delete namespaces (automatically removes interfaces)
     ip netns del red
     ip netns del blue
  '';
  aya_run = pkgs.writeShellScriptBin "aya-run" ''
    RUST_LOG=info cargo run --config 'target."cfg(all())".runner="doas "' -- \
      --iface veth-red'';
in mkShell {
  # The Nix packages provided in the environment
  packages = with pkgs;
    [
      doas
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
    echo "    aya-run - inet-up -inet-down"
  '';
}
