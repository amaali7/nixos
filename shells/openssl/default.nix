{
    pkgs,
    mkShell,
    ...
}:

mkShell {
  # Create your shell
  packages = with pkgs; [
    openssl
    pkg-config
  ];
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
