{ config, ... }:
let
  n = config.flake.modules.nixos;
  h = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.laptop = {
    imports = [ n.laptop-system ];
    home-manager.users.ergoash.imports = [
      h.laptop-tools
      h.hyprland-laptop
      h.waybar-laptop
      h.idle-laptop
    ];
  };
}
