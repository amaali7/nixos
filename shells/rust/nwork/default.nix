{ pkgs, mkShell, inputs, ... }:
mkShell {
  # The Nix packages provided in the environment
  packages = with pkgs; [ redis parallel openssl pkg-config ];
  PKG_CONFIG_PATH =
    "${pkgs.lib.makeLibraryPath (with pkgs; [ pkgs.openssl.dev ])}";

  # LIBCLANG_PATH = "${pkgs.lib.makeLibraryPath (with pkgs; [ ])}";
  shellHook = ''
    REDIS_LOG=".database/redis.log"
    mkdir -p .database

    # Check if Redis is already running
    if ! redis-cli ping &>/dev/null; then
      echo "Starting Redis in background (log: $REDIS_LOG)..."

      # Start Redis in a detached process group (avoids Nix interference)
      setsid --fork redis-server > "$REDIS_LOG" 2>&1

      # Store PID for cleanup
      REDIS_PID=$!
      echo "$REDIS_PID" > .database/redis.pid

      # Cleanup function - stops Redis if we started it
      cleanup() {
        if [[ -f ".database/redis.pid" ]]; then
          local pid=$(cat .database/redis.pid)
          if kill -0 "$pid" 2>/dev/null; then
            echo "Stopping Redis (PID: $pid)..."
            kill "$pid"
            redis-cli shutdown 2>/dev/null  # Graceful shutdown
          fi
          rm -f .database/redis.pid
        fi
      }

      # Trap both normal exit and Ctrl+C
      trap cleanup EXIT INT TERM
    else
      echo "Redis is already running."
    fi

    echo "Welcome to nix NWork Shell"
  '';
}
