{ pkgs, mkShell, ... }:

mkShell {
  # The Nix packages provided in the environment
  packages = (with pkgs; [
    # Fluff
    cargo-mommy
    onefetch
    # Bevy
    pkg-config
    alsa-lib
    vulkan-tools
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
    udev
    clang
    lld
    # If using an intel GPU
    pkgs.nixgl.nixVulkanIntel
    # If on x11
    xorg.libX11
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    # If on wayland
    libxkbcommon
    wayland
    # Rust
  ]) ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs; [ libiconv ]);
  shellHook = ''
    # Required
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
      pkgs.lib.makeLibraryPath [ pkgs.alsa-lib pkgs.udev pkgs.vulkan-loader ]
    }"
    # Aliases and other fluff/ease of use
    alias runIntel="nixVulkanIntel cargo run"
    alias runMommyIntel="nixVulkanIntel cargo mommy run"
    onefetch
    echo "Welcome to nix-hell uh nix-shell!"
  '';
}
