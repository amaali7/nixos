{ pkgs
, mkShell
, ...
}:

mkShell {
  packages = with pkgs; [
    libudev-zero
    openssl
    pkg-config
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
      pkgs.udev.dev
      pkgs.libudev-zero.out
      pkgs.openssl
      pkgs.eudev.out 
    ]}"
  '';
}
