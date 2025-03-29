{ options, config, lib, pkgs, ... }:

with lib;
with lib.amaali7;
let cfg = config.amaali7.apps.postgres;
in {
  options.amaali7.apps.postgres = with types; {
    enable = mkBoolOpt false "Whether or not to enable Pocketcasts.";
  };

  config = mkIf cfg.enable {
    # services.postgresql = {
    #   dataDir = "/data/pg";
    #   enable = true;
    #   initdbArgs = [ "--auth=trust" ];
    #   enableTCPIP = true;
    #   ensureDatabases = [ "a7db" ];
    #   identMap = ''
    #     					# ArbitraryMapName systemUser DBUser
    #     						 superuser_map      root      postgres
    #     						 superuser_map      postgres  postgres
    #     						 # Let other names login as themselves
    #     						 superuser_map      /^(.*)$   \1
    #     				'';
    #   authentication = ''
    #     					#...
    #     					#type database DBuser origin-address auth-method
    #     					# ipv4
    #     					host  all      all     127.0.0.1/32   trust
    #     					# ipv6
    #     					host all       all     ::1/128        trust
    #     				'';
    #   settings = {
    #     port = 5050;
    #     log_min_messages = "warning";
    #     log_min_error_statement = "error";
    #     log_min_duration_statement = 100; # ms
    #     log_connections = true;
    #     log_disconnections = true;
    #     log_duration = true;
    #     #log_line_prefix = '[] '
    #     log_timezone = "UTC";
    #     log_statement = "all";
    #     log_directory = "pg_log";
    #     log_filename = "postgresql-%Y-%m-%d_%H%M%S.log";
    #     logging_collector = true;

    #   };
    # };
    environment.systemPackages = with pkgs; [ postgresql dbeaver-bin ];
  };
}
