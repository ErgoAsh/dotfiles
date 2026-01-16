{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- Boot & Kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 1; # 96 MB EFI partition :C
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  zramSwap = {
    enable = true;
    # Optional: Limit max RAM usage (default is 50%)
    # memoryPercent = 50;
  };

  # --- Networking ---
  networking.hostName = "ergo-laptop"; # MUST match flake entry name
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # --- Locale & Time ---
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # --- Desktop (Cinnamon) ---
  # services.xserver.enable = true;
  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.cinnamon.enable = true;
  # services.xserver.xkb = {
  #   layout = "pl";
  #   variant = "";
  # };
  console.keyMap = "pl2";
  programs.fish.enable = true;

  programs.hyprland = {
    enable = true;
    #xwayland.enable = true; # For older apps like Discord/Steam
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
    package = pkgs.kdePackages.sddm;
  };

  # Keyring (Fixes "Enter Password" for WiFi/VS Code)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.hyprlock = { };

  # --- Audio & Services ---
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.libinput.enable = true;

  # --- Security and authentication ---
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  nixpkgs.config.permittedInsecurePackages = [
    "ciscoPacketTracer8-8.2.2"
  ];

  # --- Battery and performance ---
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;

  services.logind.settings = {
    Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "ignore";
    };
  };

  # --- User ---
  users.users.ergoash = {
    isNormalUser = true;
    description = "Marek Kida";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # --- Periodic system cleanup ---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # --- System Settings ---
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib # specific C++ libraries
    zlib # common compression
    openssl # common crypto
  ];

  system.stateVersion = "25.11";
}
