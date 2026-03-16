{
  description = "NixOS Fleet Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Base home-manager modules (shared by all hosts)
      homeBase = [
        ./home/shell.nix
        ./home/apps.nix
        ./home/gui.nix
      ];

      # Home-manager config generator
      mkHome = { extraModules ? [] }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.ergoash = {
          imports = homeBase ++ extraModules;

          home.username = "ergoash";
          home.homeDirectory = "/home/ergoash";
          home.stateVersion = "24.11";
        };
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.backupFileExtension = "backup";
      };
    in
    {
      nixosConfigurations = {

        # Host: ergo-laptop
        ergo-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/ergo-laptop/default.nix
            home-manager.nixosModules.home-manager
            (mkHome { extraModules = [ ./home/gui-laptop.nix ]; })
          ];
        };

        # Host: ergo-pc
        ergo-pc = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/ergo-pc/default.nix
            home-manager.nixosModules.home-manager
            (mkHome { extraModules = [ ./home/games.nix ]; })
          ];
        };

      };
    };
}
