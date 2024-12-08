{ pkgs, mkShell, ... }:

mkShell {
  # Create your shell
  packages = with pkgs; [ zsh tmux postgresql ];
  postgresConf = pkgs.writeText "postgresql.conf" ''
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
  LD_LIBRARY_PATH = "${pkgs.geos}/lib:${pkgs.gdal}/lib";
  PGDATA = "/home/ai3wm/.pg_data";
  DATABASE_URL = "postgres://postgres@localhost:5555/";
  TM_SH = "PostGressDB";
  # Post Shell Hook
  shellHook = ''
    echo "Using ${pkgs.postgresql.name}."

    if [ -d $PGDATA ]; then
      echo "Database Directory exists."
    else
      mkdir $PGDATA
    fi

    tmux has-session -t $TM_SH 2>/dev/null

    if [ "$?" != 0 ]; then
      tmux new-session -d -s $TM_SH -n "db_server"
      tmux send-keys -t $TM_SH:db_server "cd $PGDATA" C-m
      tmux send-keys -t $TM_SH:db_server 'export PGHOST="$PGDATA"' C-m
      # Setup: DB
      # tmux send-keys -t $TM_SH:db_server '[ ! -d $PGDATA ] && pg_ctl initdb -o "-U postgres" && cat "$postgresConf" >> $PGDATA/postgresql.conf' C-m
      tmux send-keys -t $TM_SH:db_server ' pg_ctl initdb -o "-U postgres" && cat "$postgresConf" >> $PGDATA/postgresql.conf' C-m

      tmux send-keys -t $TM_SH:db_server 'pg_ctl -o "-p 5555 -k $PGDATA" start' C-m
      tmux new-window -t $TM_SH -n "controll"
      tmux select-window -t $TM_SH:controll
    fi
    # tmux attach-session -t $SESH
  '';
}
