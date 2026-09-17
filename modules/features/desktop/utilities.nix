{ ... }: {

  flake.modules.homeManager.desktop-utilities =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      home.packages = with pkgs; [
        awww
        gammastep
        networkmanagerapplet
        libnotify
        mako
        blueman

        wl-clipboard # Clipboard manager
        grim # Screenshot tool
        slurp # Screen area selection
        pavucontrol # Audio control GUI
        playerctl # Media player control
        nerd-fonts.fira-code
        nerd-fonts.symbols-only

        alsa-utils
        nwg-displays
      ];

      programs.rofi = {
        enable = true;
        font = "JetBrainsMono Nerd Font 12";
        extraConfig = {
          modi = "drun,run";
          show-icons = true;
          display-drun = "Apps";
          display-run = "Run";
          display-window = "Window";
        };
      };

      services.gammastep = {
        enable = true;
        provider = "manual";
        latitude = 51.246452;
        longitude = 22.568445;
        temperature = {
          day = 5700;
          night = 3500;
        };
        settings = {
          general.adjustment-method = "wayland";
        };
      };

      services.mpris-proxy.enable = true;
      services.blueman-applet.enable = true;

      home.pointerCursor = {
        gtk.enable = true;
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 24;
      };

    };
}
