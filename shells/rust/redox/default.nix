{ pkgs, mkShell, ... }:

mkShell rec {
  podmanSetupScript = let
    registriesConf = pkgs.writeText "registries.conf" ''
      [registries.search]
      registries = ['docker.io']
      [registries.block]
      registries = []
    '';
  in pkgs.writeScript "podman-setup" ''
    #!${pkgs.runtimeShell}
    # Dont overwrite customised configuration
    if ! test -f ~/.config/containers/policy.json; then
      install -Dm555 ${pkgs.skopeo.src}/default-policy.json ~/.config/containers/policy.json
    fi
    if ! test -f ~/.config/containers/registries.conf; then
      install -Dm555 ${registriesConf} ~/.config/containers/registries.conf
    fi
    systemctl --user start podman.socket || true
    export PODMAN_SYSTEMD_UNIT=podman.socket
  '';
  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommandNoCC "docker-podman-compat" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.podman}/bin/podman $out/bin/docker
  '';
  # The Nix packages provided in the environment
  packages = with pkgs; [
    # Utils
    cowsay
    lolcat

    # Podman
    dockerCompat
    podman # Docker compat
    runc # Container runtime
    conmon # Container runtime monitor
    skopeo # Interact with container registry
    slirp4netns # User-mode networking for unprivileged namespaces
    fuse-overlayfs # CoW for images, much faster than default vfs

    # Build Redox
    ant
    autoconf
    automake
    bison
    cmake
    curl
    doxygen
    expat
    expect
    file
    flex
    fuse
    gmp
    gnumake
    gnupatch
    gperf
    just
    libjpeg
    libpng
    libtool
    llvmPackages.clang
    llvmPackages.llvm
    lua
    m4
    meson
    nasm
    perl
    perl540Packages.HTMLParser
    perl540Packages.Po4a
    pkgconf
    podman
    protobuf
    (python3.withPackages (ps: with ps; [ mako ]))
    qemu_kvm
    rust-cbindgen
    scons
    SDL
    syslinux
    texinfo
    unzip
    waf
    wget
    xdg-utils
    zip
  ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath packages;
  NIX_SHELL_BUILD = "1";
  shellHook = ''
    # Install required configuration
    ${podmanSetupScript}
    echo "Redox environment loaded" | cowsay | lolcat
  '';
}
