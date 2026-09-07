{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
  config.systems = [ "x86_64-linux" ];
  options.dotfiles.hosts = lib.mkOption {
    description = "Named machines assembled from explicit NixOS profile modules.";
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.modules = lib.mkOption { type = lib.types.listOf lib.types.deferredModule; };
      }
    );
  };
  config.flake.nixosConfigurations = lib.mapAttrs (
    _: host:
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = host.modules;
    }
  ) config.dotfiles.hosts;
}
