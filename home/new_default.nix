{ ... }:

{
  imports = [
    ./shell.nix
    ./gui.nix
    ./apps.nix
    ./games.nix
  ];

  home.username = "ergoash";
  home.homeDirectory = "/home/ergoash";

  # Do not change this value even if you update nixos.
  # it handles backward compatibility for state files.
  home.stateVersion = "24.11";
}
