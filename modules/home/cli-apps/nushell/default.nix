{ lib, config, inputs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.amaali7) enabled;

  cfg = config.amaali7.cli-apps.nushell;
in {
  options.amaali7.cli-apps.nushell = { enable = mkEnableOption "nushell"; };

  config = mkIf cfg.enable {

    programs = {
      nushell = {
        enable = true;
        # for editing directly to config.nu
        extraConfig = ''
          let carapace_completer = {|spans|
          carapace $spans.0 nushell ...$spans | from json
          }
          $env.config = {
           show_banner: false,
           completions: {
           case_sensitive: false # case-sensitive completions
           quick: true    # set to false to prevent auto-selecting completions
           partial: true    # set to false to prevent partial filling of the prompt
           algorithm: "fuzzy"    # prefix or fuzzy
           external: {
           # set to false to prevent nushell looking into $env.PATH to find more suggestions
               enable: true
           # set to lower can improve completion performance at the cost of omitting some options
               max_results: 100
               completer: $carapace_completer # check 'carapace_completer'
             }
           }
          }
          $env.PATH = (
              $env.PATH
              | split row (char esep)
              | prepend [
                  $"($env.HOME)/.cargo/bin"          # user cargo bin
                  $"($env.HOME)/.local/bin"  # custom release builds
                  $"($env.HOME)/.config/emacs/bin"
                ]
              | flatten
              | uniq
          )
          def dioxus_bundle_github [commit: string]  {
              let current_dir = pwd;
              rm -rf ($current_dir | path join target/dx/blogy/release/web) ;
              rm -rf ($current_dir | path join docs);
              dx bundle --renderer web -r --out-dir docs;
              let dest = ($current_dir | path join docs)
              let items = (ls ($current_dir | path join "docs/public/") | get name)
              if ($items | length) > 0 {
                  mv ...$items $dest
              }
              rm -rf ($current_dir | path join "docs/public/" )
              cp ($current_dir | path join docs/index.html) ($current_dir | path join docs/404.html);
              let items = (
                  ls ($current_dir | path join "docs/assets/")
                  | where type == file and name =~ "\\.wasm$"
                  | get name
              )
              if ($items | length) > 0 {
                  gzip -9 -k ...$items
              }
              git add .;
              git commit -m ($commit);
              git push;
          }
        '';
      };
      carapace.enable = true;
      carapace.enableNushellIntegration = true;

      starship = {
        enable = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };
    };

    home = {
      activation.linkNushell = config.lib.dag.entryAfter [ "writeBoundary" ] ''
        # ln -snf $HOME/.dotfiles/zshrc $HOME/.zshrc
      '';
    };

  };
}
