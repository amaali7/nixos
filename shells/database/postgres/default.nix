{ pkgs
, mkShell
, ...
}:

mkShell {


  packages = with pkgs; [
    zsh
    vim

    # postgres-12 with postgis support
    postgresql
  ];

  postgresConf =
    pkgs.writeText "postgresql.conf"
      ''
        # Add Custom Settings
        log_min_messages = warning
        log_min_error_statement = error
        log_min_duration_statement = 100  # ms
        log_connections = on
        log_disconnections = on
        log_duration = on
        #log_line_prefix = '[] '
        log_timezone = 'UTC'
        log_statement = 'all'
        log_directory = 'pg_log'
        log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
        logging_collector = on
        log_min_error_statement = error
      '';


  # ENV Variables
  PGDATA = "~/.pg/";
  DATABASE_URL = "postgres://postgres@localhost:5555/";
  # Post Shell Hook
  shellHook = ''
    echo "Using ${pkgs.postgresql.name}."

    # Setup: other env variables
    export PGHOST="$PGDATA"
    # Setup: DB
    [ ! -d $PGDATA ] && pg_ctl initdb -o "-U postgres" && cat "$postgresConf" >> $PGDATA/postgresql.conf
    nohup pg_ctl -o "-p 5555 -k $PGDATA" start > /dev/null &2>&1
    alias fin="pg_ctl stop"
    alias pg="psql -p 5555 -U postgres"
  '';
}
