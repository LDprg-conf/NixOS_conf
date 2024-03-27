{
  description = "A Nixos config";

  nixConfig = {
    extra-trusted-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-needsreboot = {
      url = "https://flakehub.com/f/thefossguy/nixos-needsreboot/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotx = {
      url = "github:SpotX-Official/SpotX-Bash";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, pre-commit-hooks, fenix, rust-overlay
    , spotx, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
    in rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; });
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = (import ./shell.nix { inherit pkgs; });
          precommit = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
        });

      # Add formatting via nix fmt
      formatter = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.nixpkgs-fmt);

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        LD-Laptop = let
          user = "ld";
          host = "LD-Laptop";
        in nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs user host self fenix rust-overlay spotx;
          };
          modules = [
            ./hosts
            ./hosts/${host}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs user host fenix rust-overlay;
              };
              home-manager.users.${user} = {
                imports = [ ./hosts/home.nix ./hosts/${host}/home.nix ];
              };
            }
          ];
        };
      };

      checks = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              check-added-large-files = {
                enable = true;
                name = "check-added-large-files";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-added-large-files";
              };
              check-case-conflicts = {
                enable = true;
                name = "check-case-conflicts";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-case-conflict";
                types = [ "file" ];
              };
              check-executables-have-shebangs = {
                enable = true;
                name = "check-executables-have-shebangs";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-executables-have-shebangs";
                types = [ "text" "executable" ];
              };
              check-json = {
                enable = true;
                name = "check-json";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-json";
                types = [ "json" ];
              };
              check-merge-conflicts = {
                enable = true;
                name = "check-merge-conflicts";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-merge-conflict";
                types = [ "text" ];
              };
              check-shebang-scripts-are-executable = {
                enable = true;
                name = "check-shebang-scripts-are-executable";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-shebang-scripts-are-executable";
                types = [ "text" ];
              };
              check-symlinks = {
                enable = true;
                name = "check-symlinks";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-symlinks";
                types = [ "symlink" ];
              };
              check-toml = {
                enable = true;
                name = "check-toml";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-toml";
                types = [ "toml" ];
              };
              check-xml = {
                enable = true;
                name = "check-xml";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-xml";
                types = [ "xml" ];
              };
              check-yaml = {
                enable = true;
                name = "check-yaml";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/check-yaml --multi";
                types = [ "yaml" ];
              };
              detect-private-keys = {
                enable = true;
                name = "detect-private-keys";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/detect-private-key";
                types = [ "text" ];
              };
              destroyed-symlinks = {
                enable = true;
                name = "destroyed-symlinks";
                description = "Detect the presence of private keys.";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/destroyed-symlinks";
                types = [ "text" ];
              };
              end-of-file-fixer = {
                enable = true;
                name = "end-of-file-fixer";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/end-of-file-fixer";
                types = [ "text" ];
              };
              fix-byte-order-marker = {
                enable = true;
                name = "fix-byte-order-marker";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/fix-byte-order-marker";
                types = [ "text" ];
              };
              mixed-line-endings = {
                enable = true;
                name = "mixed-line-endings";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/mixed-line-ending";
                types = [ "text" ];
              };
              pretty-format-json = {
                enable = true;
                name = "pretty-format-json";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/pretty-format-json --autofix";
                types = [ "json" ];
              };
              sort-simple-yaml = {
                enable = true;
                name = "sort-simple-yaml";
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/sort-simple-yaml";
                files = "(\\.yaml$)|(\\.yml$)";
              };
              trim-trailing-whitespace = {
                enable = true;
                name = "trim-trailing-whitespace";
                types = [ "text" ];
                entry =
                  "${pkgs.python3Packages.pre-commit-hooks}/bin/trailing-whitespace-fixer";
              };

              deadnix.enable = true;
              nil.enable = true;
              nixfmt.enable = true;
              # statix.enable = true;

              shfmt.enable = true;
            };
          };
        });
    };
}
