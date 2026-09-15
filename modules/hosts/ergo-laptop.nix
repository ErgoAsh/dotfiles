{ config, ... }:
let
  flakeConfig = config;
in
let
  n = flakeConfig.flake.modules.nixos;
in
{
  dotfiles.hosts.ergo-laptop.modules = [
    n.base
    n.desktop
    n.ergo-laptop-hardware
    n.laptop
    (
      { pkgs, ... }:

      {

        # wf-touch fails to link doctest tests on 26.05.
        nixpkgs.overlays = [
          (final: prev: {
            wf-touch = prev.wf-touch.overrideAttrs (oldAttrs: {
              mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [ "-Dtests=disabled" ];
            });
          })
        ];

        # --- Networking ---
        networking.hostName = "ergo-laptop";
        networking.networkmanager.enable = true;

        # --- Display Manager ---
        customConfig.primaryMonitor = "eDP-1";

        # --- Bootloader and kernel ---
        boot.loader.systemd-boot.enable = true;
        boot.loader.systemd-boot.configurationLimit = 5;
        boot.loader.efi.canTouchEfiVariables = true;

        boot.initrd.systemd.enable = true;

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
    )
  ];
}
