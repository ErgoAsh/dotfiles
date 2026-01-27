{
  description = "NixOS Fleet Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hytale-launcher.url = "github:JPyke3/hytale-launcher-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      hytale-launcher,
      ...
    }@inputs:
    {
      nixosConfigurations = {

        # Host: ergo-laptop
        ergo-laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/ergo-laptop/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ergoash = import ./home/default.nix;

              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };
    };
}
