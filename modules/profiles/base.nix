{ config, ... }:
let
  n = config.flake.modules.nixos;
  h = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.base = {
    imports = [
      n.home-manager
      n.system-base
      n.fish
    ];
    home-manager.users.ergoash.imports = [
      h.fish
      h.nnn
      h.helix
      h.git
      h.shell-tools
    ];
  };
}
