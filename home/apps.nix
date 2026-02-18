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
        "tridactyl.vim@cmcaine.co.uk" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi";
          installation_mode = "force_installed";
        };
        "bitwarden-password-manager@bitwarden.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      SearchEngines = {
        Default = "Google";
        Add = [
          {
            Name = "Google";
            URLTemplate = "https://www.google.com/search?q={searchTerms}";
            Method = "GET";
            IconURL = "https://www.google.com/favicon.ico";
            Alias = "@g";
          }
        ];
      };
    };

    profiles.ergoash = {
      isDefault = true;
      settings = {
        "privacy.resistFingerprinting" = false;
        "browser.privatebrowsing.autostart" = false;
        "privacy.history.custom" = true;
        "browser.startup.homepage" = "https://google.com";
        "browser.search.region" = "PL";
        "browser.search.isUS" = false;
        "librewolf.cfg.default_search_engine" = "Google";
        "browser.startup.page" = 3; # Resume previous session
        "network.cookie.lifetimePolicy" = 0;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;
        "media.eme.enabled" = true;
        "media.gmp-widevinecdm.visible" = true;
        "media.gmp-widevinecdm.enabled" = true;
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
