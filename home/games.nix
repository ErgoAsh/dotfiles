{ pkgs, ... }:

{
  home.packages = with pkgs; [
    steam

    # --- Modding ---
    steamtinkerlaunch
    protontricks
    yad

    # You can move other game-related packages here if you want
    # lutris
    # heroic
    #

    prismlauncher

    #jdk8   # For versions 1.16 and older (like 1.12.2 or 1.7.10)
    #jdk17  # For versions 1.17 - 1.20.4
    jdk21 # For versions 1.20.5 and newer
  ];
}
