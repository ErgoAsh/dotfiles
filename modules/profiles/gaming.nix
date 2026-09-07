{ config, ... }:
let
  n = config.flake.modules.nixos;
  h = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.gaming = {
    imports = [ n.gaming-system ];
    home-manager.users.ergoash.imports = [ h.gaming ];
  };
}
