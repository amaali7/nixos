{ pkgs, mkShell, ... }:

mkShell {
  packages = with pkgs; [ python312Packages.tabula-py openjdk8-bootstrap ];
  OPENSSL_NO_VENDOR = 1;
  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
      pkgs.lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.openssl ]
    }"
  '';
}
