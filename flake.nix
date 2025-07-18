{
  description = "Amaali7";
  nixConfig = {
    extra-substituters = [
      # "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://raspberry-pi-nix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="
    ];
    builders = "";
    sandbox = "relaxed";
  };
  inputs = {
    # NixPkgs (nixos-23.11)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # NixPkgs Unstable (nixos-unstable)
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    kmyc = {
      url = "github:amaali7/kde-material-you-colors-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Lix
    lix = {
      url =
        "https://git.lix.systems/lix-project/nixos-module/archive/2.93.2-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    # Home Manager (release-22.05)
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    matugen = {
      url = "github:/InioX/Matugen";
      # If you need a specific version:
    };
    # macOS Support (master)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware Configuration
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Aylur AGS shell
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "unstable";
    };

    # Aylur AGS shell
    ags = {
      #url = "github:Aylur/ags?ref=v2.3.0";
      url = "github:AhmedSaadi0/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # niri.url = "github:sodiboo/niri-flake";
    # stylix = {
    #   url = "github:danth/stylix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # quickshell = {
    #   url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Generate System Images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib?ref=v3.0.3"; # ?ref=v2.1.1";
    # snowfall-lib.url = "github:snowfallorg/lib"; # ?ref=v2.1.1";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # SuperFile
    superfile = {
      url = "github:/yorukot/superfile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Zen Browser
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Flake
    flake.url = "github:snowfallorg/flake?ref=v1.4.1";
    flake.inputs.nixpkgs.follows = "unstable";

    # Snowfall Thaw
    thaw.url = "github:snowfallorg/thaw?ref=v1.0.7";

    # Comma
    comma.url = "github:nix-community/comma";
    comma.inputs.nixpkgs.follows = "unstable";

    # System Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "unstable";

    # Run unpatched dynamically compiled binaries
    nix-ld.url = "github:nix-community/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # Neovim
    neovim.url = "github:amaali7/nixvim";
    neovim.inputs.nixpkgs.follows = "unstable";

    # Tmux
    tmux.url = "github:jakehamilton/tmux";
    tmux.inputs = {
      nixpkgs.follows = "nixpkgs";
      unstable.follows = "unstable";
    };

    # Discord Replugged
    replugged.url = "github:LunNova/replugged-nix-flake";
    replugged.inputs.nixpkgs.follows = "unstable";

    # Discord Replugged plugins / themes
    discord-tweaks = {
      url = "github:NurMarvin/discord-tweaks";
      flake = false;
    };
    #discord-nord-theme = {
    #  url = "github:DapperCore/NordCord";
    #  flake = false;
    #};

    # GPG default configuration
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };

    bibata-cursors = {
      url = "github:suchipi/Bibata_Cursor";
      flake = false;
    };

    snowfall-docs = {
      url = "github:snowfallorg/docs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # build with your own instance of nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = { url = "github:nix-community/nur"; };
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-f2k = {
      url = "github:fortuneteller2k/nixpkgs-f2k";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;
        homes.modules = with inputs;
          [
            # my-input.homeModules.my-module
            niri.homeModules.niri
          ];
        snowfall = {
          namespace = "amaali7";
          meta = {
            name = "amaali7";
            title = "Amaali7";
          };
        };
      };
    in lib.mkFlake {
      templates = {
        python.description = "This is python 3.11 env using nix flake!";
      };

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          #   # @FIXME(jakehamilton): This is a workaround for 22.11 and can
          #   # be removed once NixPkgs is upgraded to 23.05.
          #   # "electron-20.3.11"
          #   # "nodejs-16.20.0"
          #   # "python-2.7.18.6"
          #   "electron-24.8.6"
          #   # "electron-22.3.27"
          # "electron-25.9.0"
          # "nix-2.15.3"
          "electron-27.3.11"
          "dotnet-runtime-6.0.36"
          "dotnet-sdk-wrapped-6.0.428"
          "dotnet-sdk-6.0.428"
        ];
      };
      overlays = with inputs; [
        neovim.overlays.default
        flake.overlays.default
        # snowfall-docs.overlays
        nixgl.overlay
        # lix.overlays.default
        nixpkgs-f2k.overlays.default
        yazi.overlays.default
      ];

      systems.modules.nixos = with inputs; [
        # niri.nixosModules.niri
        home-manager.nixosModules.home-manager
        nur.modules.nixos.default
        nix-ld.nixosModules.nix-ld
        # nix-ld.nixosModules.nix-ld
        lix.nixosModules.default
        # @TODO(jakehamilton): Replace amaali7.services.attic now that vault-agent
        # exists and can force override environment files.
        # attic.nixosModules.atticd
      ];
      systems.hosts.laptop.modules = with inputs;
        [
          # niri.homeModules.niri
          nixos-hardware.nixosModules.dell-latitude-7390

        ];
      #
      deploy = lib.mkDeploy { inherit (inputs) self; };

      checks = builtins.mapAttrs
        (system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;
    };
}
