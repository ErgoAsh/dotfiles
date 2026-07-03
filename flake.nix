{
  description = "NixOS Fleet Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # Base home-manager modules (shared by all hosts)
      homeBase = [
        ./home/shell.nix
        ./home/apps.nix
        ./home/gui.nix
      ];

      # Home-manager config generator
      mkHome =
        {
          extraModules ? [ ],
        }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ergoash = {
            imports = homeBase ++ extraModules;

            home.username = "ergoash";
            home.homeDirectory = "/home/ergoash";
            home.stateVersion = "26.05";
          };
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          home-manager.backupFileExtension = "backup";
        };
    in
    {
      formatter.${system} = pkgs.nixfmt-tree;

      nixosConfigurations = {

        # Host: ergo-laptop
        ergo-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./hosts/ergo-laptop/default.nix
            home-manager.nixosModules.home-manager
            (mkHome { extraModules = [ ./home/gui-laptop.nix ]; })
          ];
        };

        # Host: ergo-pc
        ergo-pc = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./hosts/ergo-pc/default.nix
            home-manager.nixosModules.home-manager
            (mkHome {
              extraModules = [
                ./home/games.nix
                ./home/hyprland-pc.nix
              ];
            })
          ];
        };

      };
    };
}
