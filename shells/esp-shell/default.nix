{ pkgs, mkShell, ... }:

mkShell {
  packages = with pkgs; [ openssl cargo-xbuild rust-bindgen ];

  shellHook = ''
    export DEBUG=1
    export LIBCLANG_PATH="/home/ai3wm/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-18.1.2_20240912/esp-clang/lib"
    export PATH="/home/ai3wm/.rustup/toolchains/esp/xtensa-esp-elf/esp-14.2.0_20240906/xtensa-esp-elf/bin:$PATH"
  '';
}
