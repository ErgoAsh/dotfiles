{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
  ];

  # --- Networking ---
  networking.hostName = "ergo-pc";
  networking.networkmanager.enable = true;

  # --- Display Manager ---
  # Check monitor name with: hyprctl monitors
  # Common options: HDMI-A-1, DP-1, DP-2
  customConfig.primaryMonitor = ""; # Empty = span all monitors

  # --- Bootloader and kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 15;
  boot.loader.systemd-boot.consoleMode = "max";

  # Use the Zen kernel for better desktop responsiveness
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [
    "i2c-dev"
    "i2c-piix4"
  ];

  # --- Graphics (AMD specific) ---
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Essential for Steam/Wine

    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.rocminfo
    ];
  };

  # --- Hardware and power ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # CPU power management (desktop - always performance)
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  # Disable conflicting power services
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  services.hardware.openrgb.enable = true;

  # --- Storage Optimization ---
  # Enable ZRAM (swap in RAM)
  zramSwap = {
    enable = true;
    # memoryPercent = 50; # Default is 50%
  };

  # SSD trim (weekly)
  services.fstrim.enable = true;
}
