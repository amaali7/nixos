{ pkgs, mkShell, ... }:

mkShell {
  packages = with pkgs; [ openssl cargo-xbuild rust-bindgen ];

  shellHook = ''
    export DEBUG=1
    export PATH="/home/ai3wm/.rustup/toolchains/esp/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/bin:$PATH"
    export LIBCLANG_PATH="/home/ai3wm/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-17.0.1_20240419/esp-clang/lib"
  '';
}
