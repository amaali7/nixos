{ pkgs, mkShell, ... }:

mkShell {
  packages = with pkgs; [ openssl cargo-xbuild rust-bindgen ];

  shellHook = ''
    export DEBUG=1
    $HOME/export-esp.sh
  '';
}
