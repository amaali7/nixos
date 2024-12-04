{ options, config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.develop.python;
in {
  options.amaali7.develop.python = with types; {
    enable = mkBoolOpt false "Whether or not to enable python.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      python312
      python312Packages.setuptools
      python312Packages.poetry-core
      python312Packages.pip
      python312Packages.black
      python312Packages.pyflakes
      python312Packages.pytest
      poetry
    ];
  };
}
