{ pkgs, pkgs-unstable, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/laptop.nix
  ];

  # wf-touch fails to link doctest tests on 26.05; hyprgrass in nixpkgs is too old for Hyprland 0.55.
  nixpkgs.overlays = [
    (final: prev: {
      wf-touch = prev.wf-touch.overrideAttrs (oldAttrs: {
        mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [ "-Dtests=disabled" ];
      });

      hyprlandPlugins = prev.hyprlandPlugins // {
        hyprgrass = prev.hyprlandPlugins.hyprgrass.overrideAttrs (oldAttrs: {
          version = "0.8.2-unstable-2026-06-06";
          src = prev.fetchFromGitHub {
            owner = "horriblename";
            repo = "hyprgrass";
            rev = "c9968ba79b3537eff127d6ab6df767d76f17544a";
            hash = "sha256-rVLdIs67in1fhaatayWrLu+kCOJ0cveKze/BRjYtxRw=";
          };
          doCheck = false;
        });
      };
    })
  ];

  # --- Networking ---
  networking.hostName = "ergo-laptop";
  networking.networkmanager.enable = true;

  # --- Display Manager ---
  customConfig.primaryMonitor = "eDP-1";

  # --- Bootloader and kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 1; # 96 MB EFI partition
  boot.loader.efi.canTouchEfiVariables = true;

  # Systemd initrd (~54 MB) + zen kernel (~14 MB) + ESP overhead (~28 MB) ≈ 97 MB > 96 MB.
  # Scripted initrd is smaller and fits; use systemd initrd after resizing EFI to ≥128 MB.
  boot.initrd.systemd.enable = false;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # --- Graphics (AMD) ---
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.rocminfo
    ];
  };

  # --- Bluetooth ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # --- Storage ---
  zramSwap.enable = true;
  services.fstrim.enable = true;

  # --- Insecure packages (if needed) ---
  nixpkgs.config.permittedInsecurePackages = [
    "ciscoPacketTracer8-8.2.2"
  ];
}
