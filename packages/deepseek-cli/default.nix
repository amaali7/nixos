{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "deepseek-cli";
  version = "0.2.0";

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cat > $out/bin/deepseek <<'EOF'
    #!/bin/sh
    set -euo pipefail

    # Configuration
    CONFIG_DIR="''${DEEPSEEK_CONFIG_DIR:-$HOME/.config/deepseek}"
    KEY_FILE="$CONFIG_DIR/api-key"
    API_ENDPOINT="https://api.deepseek.com/v1/refactor"

    # Key handling
    API_KEY=''${DEEPSEEK_API_KEY:-$(cat "$KEY_FILE" 2>/dev/null | ${pkgs.gnused}/bin/sed '/^$/d')}

    if [ -z "$API_KEY" ]; then
      echo "🔑 Error: No API key found. Either:" >&2
      echo "1. Set DEEPSEEK_API_KEY environment variable" >&2
      echo "2. Create $KEY_FILE with your key" >&2
      exit 1
    fi

    if ! [[ "$API_KEY" =~ ^[a-zA-Z0-9]{32,}$ ]]; then
      echo "❌ Error: Malformed API key (expected 32+ alphanumeric chars)" >&2
      exit 1
    fi

    # Argument parsing
    INPUT_FILE=""
    REQUEST=""
    FORMAT="text"

    while [ $# -gt 0 ]; do
      case "$1" in
        -i|--input)
          INPUT_FILE="$2"
          shift 2
          ;;
        -r|--request)
          REQUEST="$2"
          shift 2
          ;;
        -f|--format)
          FORMAT="$2"
          shift 2
          ;;
        -h|--help)
          echo "Usage: deepseek -i <file> -r <request> [-f text|json]"
          exit 0
          ;;
        *)
          echo "❌ Unknown option: $1" >&2
          exit 1
          ;;
      esac
    done

    # Validation
    if [ -z "$INPUT_FILE" ] || [ -z "$REQUEST" ]; then
      echo "❌ Missing required arguments" >&2
      echo "Usage: deepseek -i <file> -r <request> [-f text|json]" >&2
      exit 1
    fi

    # Process input
    if [ "$INPUT_FILE" = "-" ]; then
      INPUT_CONTENT=$(cat)
    else
      INPUT_CONTENT=$(cat "$INPUT_FILE")
    fi

    # API call
    response=$(${pkgs.curl}/bin/curl -sS -X POST \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d "$(${pkgs.jq}/bin/jq -n \
        --arg input "$INPUT_CONTENT" \
        --arg request "$REQUEST" \
        '{input: $input, request: $request}')" \
      "$API_ENDPOINT")

    # Output handling
    case "$FORMAT" in
      json) echo "$response" ;;
      text) echo "$response" | ${pkgs.jq}/bin/jq -r '.text' ;;
      *) echo "❌ Invalid format: $FORMAT" >&2; exit 1 ;;
    esac
    EOF

    chmod +x $out/bin/deepseek
    wrapProgram $out/bin/deepseek \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.curl pkgs.jq pkgs.gnused ]}
  '';

  meta = with pkgs.lib; {
    description = "Robust CLI wrapper for DeepSeek API";
    homepage = "https://deepseek.com";
    license = licenses.mit;
  };
}
