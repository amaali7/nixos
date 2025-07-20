{ pkgs, mkShell, ... }:

mkShell {
  packages = with pkgs; [ sqlite openssl pkg-config ];
  OPENSSL_NO_VENDOR = 1;
  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
      pkgs.lib.makeLibraryPath [ pkgs.sqlite pkgs.openssl ]
    }"
  '';
}
