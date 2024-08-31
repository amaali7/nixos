{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.postgres;
in {
  options.amaali7.apps.postgres = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pocketcasts.";
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      dataDir = "/data/pg";
      enable = true;
      enableTCPIP = true;
      settings = {
        port = 5050;
        log_min_messages = "warning";
        log_min_error_statement = "error";
        log_min_duration_statement = 100; # ms
        log_connections = true;
        log_disconnections = true;
        log_duration = true;
        #log_line_prefix = '[] '
        log_timezone = "UTC";
        log_statement = "all";
        log_directory = "pg_log";
        log_filename = "postgresql-%Y-%m-%d_%H%M%S.log";
        logging_collector = true;

      };
    };
    environment.systemPackages = with pkgs; [ postgresql dbeaver-bin ];
  };
}
