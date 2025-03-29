{ pkgs, mkShell, ... }:

mkShell {
  packages = with pkgs; [ udev openssl pkg-config ];
  OPENSSL_NO_VENDOR = 1;
  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
      pkgs.lib.makeLibraryPath [ pkgs.udev pkgs.openssl ]
    }"
  '';
}
