{ options, config, pkgs, lib, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.user;
in {
  options.amaali7.user = with types; {
    name = mkOpt str "ai3wm" "The name to use for the user account.";
    fullName = mkOpt str "Abdallah Adam" "The full name of the user.";
    email = mkOpt str "amaali1991@gmail.com" "The email of the user.";
    initialPassword = mkOpt str "password"
      "The initial password to use when the user is first created.";
    icon = mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [ ] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs { }
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    users.users."${cfg.name}" = {
      isNormalUser = true;

      inherit (cfg) name initialPassword;

      home = "/home/${cfg.name}";
      group = "users";

      # Arbitrary user ID to use for the user. Since I only
      # have a single user on my machines this won't ever collide.
      # However, if you add multiple users you'll need to change this
      # so each user has their own unique uid (or leave it out for the
      # system to select).
      # uid = 1000;

      extraGroups = [
        "storage"
        "plugdev"
        "disk"
        "wheel"
        "dialout"
        "network"
        "docker"
        "adbusers"
        "kvm"
        "podman"
      ] ++ cfg.extraGroups;
    } // cfg.extraOptions;
  };
}
