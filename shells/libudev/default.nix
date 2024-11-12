{ pkgs
, mkShell
, ...
}:

mkShell {
  packages = with pkgs; [
    libudev-zero
    udev
    openssl
    pkg-config
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
      pkgs.udev
      pkgs.libudev-zero
      pkgs.openssl
      pkgs.eudev.out 
    ]}"
  '';
}
