{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/laptop.nix
  ];

  # --- Networking ---
  networking.hostName = "ergo-laptop";
  networking.networkmanager.enable = true;

  # --- Bootloader and kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 1; # 96 MB EFI partition
  boot.loader.efi.canTouchEfiVariables = true;

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
