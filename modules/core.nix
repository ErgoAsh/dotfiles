{ pkgs, pkgs-unstable, ... }:

{
  # --- Nix & NixPKGS Configuration ---
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Periodic system cleanup (garbage collection)
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

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

  # Console keyboard layout (TTY)
  console.keyMap = "pl2";

  # --- User Configuration ---
  users.users.ergoash = {
    isNormalUser = true;
    description = "Marek Kida";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "realtime"
    ];
    shell = pkgs.fish;
  };

  # Enable Fish at system level so user shell works
  programs.fish.enable = true;

  # --- Security authentication ---
  # YubiKey / SmartCard support (PCSC)
  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # --- System compatibility (Nix-LD) ---
  # Essential for running unpatched binaries (VSCode servers, language LSPs, etc)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib # standard C++ libraries
    zlib # common compression
    openssl # common crypto
  ];

  # --- Basic System Utilities ---
  # Packages that should be available on every single machine
  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
    file
    killall
  ];

  # --- State Version ---
  system.stateVersion = "24.11";
}
