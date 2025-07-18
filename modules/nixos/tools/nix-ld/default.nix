{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.tools.nix-ld;
in {
  options.amaali7.tools.nix-ld = with types; {
    enable = mkBoolOpt false "Whether or not to enable nix-ld.";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.dev.enable = true;
    programs.nix-ld.dev.libraries = with pkgs; [ sqlite ];
    environment.systemPackages =
      [ inputs.nix-alien.packages.${pkgs.system}.nix-alien ];
  };
}
