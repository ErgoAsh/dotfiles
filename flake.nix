{
	description = "Basic Nix flake config";

	# Flake schema reference: https://nixos.wiki/wiki/Flakes
	inputs = {
		# Using both a stable and unstable nixpkgs is a good idea, as it allows you to
		# use the latest packages for some things, while still having a stable base.
		# When a new version of nixpkgs comes out, like 23.05, you just need to change the
		# nixpkgs.url to point to the new version, and then run `nix flake update` to update.
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

		home-manager.url = "github:nix-community/home-manager/release-24.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	# Outputs is a function that as its arguments takes the optupts of specified flakes,
	# as well as its own output (self). In case the syntax is unclear, here's the
	# nix function syntax referrence: https://nixos.wiki/wiki/Overview_of_the_Nix_Language#Functions
	outputs =
	{ self, nixpkgs, home-manager, ... }@inputs:
	let
		username = "ergoash";
		system = "x86_64-linux";
	in
	{
		nixosConfigurations = {
			"server-wyse" = nixpkgs.lib.nixosSystem {
				modules = [
					./hosts/server-wyse/configuration.nix
					#./home-manager/default/configuration.nix
				];
			};

			#"server-rpi" = nixpkgs.lub.nixosSystem {
			#	modules = [
			#		./hosts/server-rpi/configuration.nix
			#	];
			#};
			
			#"desktop-laptop-hp" = nixpkgs.lub.nixosSystem {
			#	modules = [
			#		./hosts/desktop-laptop-hp/configuration.nix
			#	];
			#};
			
			#"desktop-pc-amd" = nixpkgs.lub.nixosSystem {
			#	modules = [
			#		./hosts/desktop-pc-amd/configuration.nix
			#	];
			#};
		};

		homeConfigurations = {
			"ergoash@server-wyse" = home-manager.lib.homeManagerConfiguration {
				pkgs = nixpkgs.legacyPackages.${system};
				modules = [
					./home-manager/server-wyse/home.nix
				];
			};

			#"ergoash@server-rpi" = home-manager.lib.homeManagerConfiguration {
			#	pkgs = nixpkgs.legacyPackages.${system};
			#	modules = [
			#		./home-manager/server-rpi/home.nix
			#	];
			#};

			#"ergoash@desktop-laptop-hp" = home-manager.lib.homeManagerConfiguration {
			#	pkgs = nixpkgs.legacyPackages.${system};
			#	modules = [
			#		./home-manager/desktop-laptop-hp/home.nix
			#	];
			#};

			#"ergoash@desktop-pc-amd" = home-manager.lib.homeManagerConfiguration {
			#	pkgs = nixpkgs.legacyPackages.${system};
			#	modules = [
			#		./home-manager/desktop-pc-amd/home.nix
			#	];
			#};
		};
	};
}
