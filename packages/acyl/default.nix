{ stdenv, pkgs, fetchFromGitHub }:

#pkgs.python3Packages.buildPythonPackage {
stdenv.mkDerivation {
  pname = "acyl-icons";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "worron";
    repo = "ACYLS";
    rev = "a1c58328edabde1e69b8613a55c68176b9d4359a";
    sha256 = "1k0d5zvbx9kjd3hj8xfx4ds77l2y9l4vklvdfcy7gyqssa9448xy";
    fetchSubmodules = false;
  };

  propagatedBuildInputs = with pkgs; [
    python312Packages.pycairo
    python312Packages.pygobject3
    gobject-introspection
    glib
    gtk3
    python312Packages.lxml
    dconf
  ];

  installPhase = ''
    mkdir -p $out/usr/share/icons/ACYL
    cp -R $src/* $out/usr/share/icons/ACYL
    mkdir -p $out/usr/share/applications
    cp $src/desktop/acyls.desktop $out/usr/share/applications/
    substituteInPlace  $out/usr/share/applications/acyls.desktop --replace  "~/.icons/ACYLS/scripts/run.py" "$out/usr/share/icons/ACYL/scripts/run.py"
  '';

  meta.description = "Monaco font but patched with the nerd fonts tool!";
}
