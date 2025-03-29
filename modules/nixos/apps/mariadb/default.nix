{ pkgs, config, lib, ... }:
with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.mariadb;
in {
  options.amaali7.apps.mariadb = with types; {
    enable = mkBoolOpt false "Whether or not to enable i3.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mysql-workbench ];
    # https://devenv.sh/reference/options/
    services.mysql.package = pkgs.mariadb;
    services.mysql.enable = true;

    # https://shyim.me/blog/devenv-compose-developer-environment-for-php-with-nix/
    services.mysql.initialDatabases = [{ name = "fiveg"; }];
    services.mysql.ensureUsers = [{
      name = "fiveg";
      # password = "fiveg";
      ensurePermissions = { "fiveg" = "ALL PRIVILEGES"; };
    }];

    # Project specific MySQL config like require always a primary key
    services.mysql.settings.mysqld = { "sql_require_primary_key" = "off"; };
  };
}
