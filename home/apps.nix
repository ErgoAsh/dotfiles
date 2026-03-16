{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # --- Productivity & office ---
    obsidian
    vesktop
    anki
    (lib.lowPrio pcloud)
    zotero
    xournalpp
    hardinfo2
    geany
    wdisplays
    ticktick
    thunderbird
    teams-for-linux
    libreoffice-fresh

    openrgb-with-all-plugins

    mission-center
    qdirstat
    gnome-disk-utility
    file-roller
    xarchiver

    # --- Music ---
    ardour
    qpwgraph
    sfizz-ui

    # --- Chat & social ---
    vesktop
    teams-for-linux

    # --- Media ---
    spotify
    vlc
    imv

    # --- Development & tools ---
    hardinfo2
    jetbrains.pycharm
    jetbrains.clion

    # --- Browser extensions (native connectors) ---
    tridactyl-native
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  # --- Browser (LibreWolf) ---
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };

        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
          installation_mode = "force_installed";
        };

        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
          installation_mode = "force_installed";
        };

        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "force_installed";
        };

        "zotero@chnm.gmu.edu" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/zotero-connector/latest.xpi";
          installation_mode = "force_installed";
        };

        "besttimetracker@example.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/besttimetracker/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      SearchEngines = {
        Default = "Google Search";
        PreventInstalls = false;
        Add = [
          {
            Name = "Google Search";
            URLTemplate = "https://www.google.com/search?q={searchTerms}";
            Method = "GET";
            IconURL = "https://www.google.com/favicon.ico";
            Alias = "@g";
            Description = "Google Search";
          }
        ];
      };
    };

    profiles.ergoash = {
      isDefault = true;

      userContent = ''
        * {
          scrollbar-width: auto !important;
          scrollbar-color: #888888 #1a1a1a !important;
        }
      '';

      settings = {
        "widget.gtk.overlay-scrollbars.enabled" = false;
        "widget.non-native-theme.scrollbar.size.override" = 24;
        "widget.non-native-theme.scrollbar.style" = 4;

        "keyword.enabled" = true;
        "browser.search.widget.inNavBar" = true;
        "browser.urlbar.suggest.searches" = true;

        "privacy.resistFingerprinting" = false;
        "browser.privatebrowsing.autostart" = false;
        "privacy.history.custom" = true;
        "browser.startup.homepage" = "https://google.com";
        "network.cookie.lifetimePolicy" = 0;

        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;

        "media.eme.enabled" = true;
        "media.gmp-widevinecdm.visible" = true;
        "media.gmp-widevinecdm.enabled" = true;

        "browser.safebrowsing.malware.enabled" = true;
        "browser.safebrowsing.phishing.enabled" = true;
        "browser.safebrowsing.blockedURIs.enabled" = true;
      };
    };
  };

  # --- Terminal (WezTerm) ---
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require 'wezterm'
      return {
        font = wezterm.font 'FiraCode Nerd Font',
        font_size = 12.0,
        color_scheme = 'Catppuccin Mocha',
        window_background_opacity = 0.75,
        enable_tab_bar = true,
        window_close_confirmation = 'NeverPrompt',
      }
    '';
  };

  # --- Code editor (VSCode) ---
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  # --- Screenshot tool (flameshot) ---
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        disabledGrimWarning = true;
      };
    };
  };
}
