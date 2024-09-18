{ pkgs
, mkShell
, ...
}:

mkShell {
  packages = with pkgs; [
    libudev-zero
  ];

  shellHook = ''
  '';
}
