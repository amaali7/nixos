{pkgs, ...}:
{
pkgs.python3Packages.buildPythonPackage rec {
  name = "mypackage";
  src = ./path/to/source;
  propagatedBuildInputs = [ pytest numpy pkgs.libsndfile ];
}
}
