{ lib, runCommandNoCC, namespace, ... }:
let
  inherit (lib.${namespace}) override-meta;

  # Taken from https://docs.ubports.com/en/latest/userguide/install.html#missing-udev-rules
  rules = ./69-probe-rs.rules;

  new-meta = with lib; {
    description =
      "A helper to list all of the NixOS hosts available from your flake.";
    license = licenses.mit;
    maintainers = with maintainers; [ abdallah ];
  };

  package = runCommandNoCC "probe-rs-udev-rules" {
    meta = with lib; {
      description = "udev rules for the probe-rs.";
      homepage = "https://probe.rs/docs/getting-started/probe-setup/";
      license = licenses.mit;
      maintainers = with maintainers; [ abdallah ];
      platforms = [ "x86_64-linux" ];
    };
  } ''
    cp ${rules} 69-probe-rs.rules

    mkdir -p $out/lib/udev/rules.d

           cp 69-probe-rs.rules $out/lib/udev/rules.d/69-probe-rs.rules
  '';
in override-meta new-meta package
