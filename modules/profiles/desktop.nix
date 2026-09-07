{ config, ... }:
let
  n = config.flake.modules.nixos;
  h = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.desktop = {
    imports = [
      n.hyprland
      n.greeter
      n.audio
      n.thunar
      n.desktop-services
    ];
    home-manager.users.ergoash.imports = [
      h.apps
      h.mime
      h.thunar
      h.librewolf
      h.wezterm
      h.vscode
      h.flameshot
      h.chatgpt
      h.hyprland
      h.waybar
      h.notifications
      h.lock
      h.idle
      h.midi-idle
      h.desktop-utilities
    ];
  };
}
