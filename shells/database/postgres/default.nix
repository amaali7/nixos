{
    pkgs,
    mkShell,
    ...
}:

mkShell {
	nativeBuildInputs = with pkgs; [
    openssl
    pkg-config
  ];
  PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
