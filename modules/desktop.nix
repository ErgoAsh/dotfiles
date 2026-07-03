{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:

{
  options.customConfig.primaryMonitor = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Primary monitor for display manager (greeter)";
  };

  config = {
    # --- Hyprland (system level) ---
    programs.hyprland = {
      enable = true;
    };

    # --- Desktop portals ---
    # Required by Electron/GTK apps for file choosers, screen sharing, and desktop integration.
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = [
        "hyprland"
        "gtk"
      ];
    };

    # --- Display manager (greeter) ---
    # Using Regreet sitting on top of Cage (Wayland kiosk)
    programs.regreet = {
      enable = true;
      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
      };
      settings = {
        background = {
          path = ../wallpapers/wallhaven-lyz3d2.png;
          fit = "Cover";
        };
        GTK.application_prefer_dark_theme = true;
      };
    };

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            let
              monitorArg =
                if config.customConfig.primaryMonitor != "" then "-m ${config.customConfig.primaryMonitor}" else "";
              cageCmd = "${pkgs.cage}/bin/cage -s ${monitorArg} -- ${pkgs.regreet}/bin/regreet";
            in
            "${pkgs.dbus}/bin/dbus-run-session sh -lc 'export XCURSOR_SIZE=16; exec ${cageCmd}'";
          user = "greeter";
        };
      };
    };

    # --- Audio and sound (Pipewire) ---
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      wireplumber.extraConfig = {
        "99-no-logind-mute" = {
          "wireplumber.settings" = {
            "logind.screen-lock-timeout" = 0;
          };
        };
      };
    };

    security.pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "99";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "soft";
        value = "99999";
      }
      {
        domain = "@audio";
        item = "nofile";
        type = "hard";
        value = "99999";
      }
    ];

    # --- File Management Services ---
    # Thunar is here because it often requires system services (GVFS/Tumbler)
    # to work correctly for mounting drives.
    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    services.gvfs.enable = true; # Mount, Trash, and other file system services
    services.tumbler.enable = true; # Thumbnail support for images

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
