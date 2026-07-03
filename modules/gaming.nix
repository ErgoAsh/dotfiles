{ pkgs, pkgs-unstable, ... }:

{
  # --- Steam ---
  # Enabling Steam at the system level is preferred over Home Manager
  # because it configures udev rules for controllers and firewall ports.
  programs.steam = {
    enable = true;

    # Open ports for Steam Remote Play (optional)
    remotePlay.openFirewall = true;

    # Open ports for local dedicated servers (optional)
    dedicatedServer.openFirewall = true;

    # Fix for some games that need higher file descriptor limits
    # (e.g. some paradox games or heavy modpacks)
    gamescopeSession.enable = true;
  };

  # --- GameMode ---
  # Optimizes system performance on demand (run games with `gamemoderun %command%`)
  programs.gamemode.enable = true;

  # --- Gamescope ---
  # A micro-compositor from Valve. Great for upscaling or fixing focus issues.
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Allow gamescope to renice itself for better performance
  };

  # --- Graphics drivers ---
  # Ensure 32-bit support is enabled (critical for Wine/Proton)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # --- Useful tools ---
  environment.systemPackages = with pkgs; [
    mangohud # FPS overlay
    protonup-qt # GUI to install GE-Proton versions
    jdk21 # Minecraft / Prism Launcher (1.20.5+); kept out of HM to avoid JDK header collisions with JetBrains IDEs
  ];
}
