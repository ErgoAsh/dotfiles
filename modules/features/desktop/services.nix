{ ... }: {

  flake.modules.nixos.desktop-services = { pkgs, ... }: {
    # --- Security & Keyring ---
    # Fixes "Enter Password" for WiFi/VS Code/Chrome
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.pam.services.hyprlock = { }; # Unlock keyring on unlock

    # --- Printing & Discovery ---
    services.printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # --- Input & peripherals ---
    services.libinput.enable = true;

    # --- Fonts ---
    # Essential for the Greeter to render text/icons correctly before user login
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}
