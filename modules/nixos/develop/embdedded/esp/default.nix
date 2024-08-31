{ config, lib, pkgs, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.develop.embdedded.esp;
in {
  options.amaali7.develop.embdedded.esp = with types; {
    enable = mkBoolOpt false "Whether or not to enable embdedded";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        espup
        cargo-espmonitor
        esptool
				llvmPackages_latest.llvm
				clang
				clang-tools
      ];
  };
}
