{ inputs, ... }: {
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      users.ergoash = {
        home.username = "ergoash";
        home.homeDirectory = "/home/ergoash";
        home.stateVersion = "26.05";
      };
    };
  };
}
