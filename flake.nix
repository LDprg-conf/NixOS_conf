{
  description = "LDprg's Nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
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

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotx = {
      url = "github:SpotX-Official/SpotX-Bash";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , chaotic
    , nur
    , home-manager
    , pre-commit-hooks
    , fenix
    , rust-overlay
    , spotx
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    rec {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = import ./shell.nix { inherit pkgs; };
          precommit = pkgs.mkShell { inherit (self.checks.${system}.pre-commit-check) shellHook; };
        }
      );

      formatter = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        pkgs.nixpkgs-fmt
      );

      nixosConfigurations = {
        LD-Laptop =
          let
            user = "ld";
            host = "LD-Laptop";
          in
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit
                inputs
                outputs
                user
                host
                self
                fenix
                rust-overlay
                spotx
                ;
            };
            modules = [
              ./hosts
              ./hosts/${host}
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit
                      inputs
                      outputs
                      user
                      host
                      fenix
                      rust-overlay
                      ;
                  };
                  users.${user} = {
                    imports = [
                      ./hosts/home.nix
                      ./hosts/${host}/home.nix
                    ];
                  };
                };
              }
              chaotic.nixosModules.default
              nur.nixosModules.nur
            ];
          };
      };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./precommit.nix { inherit pkgs system pre-commit-hooks; }
      );
    };
}
