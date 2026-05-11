{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # --- Productivity & office ---
      obsidian
      vesktop
      anki
      (lib.lowPrio pcloud)
      xournalpp
      hardinfo2
      geany
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

      # --- Media ---
      spotify
      vlc
      imv
      zathura

      # --- Development & tools ---
      hardinfo2
      claude-code
      jetbrains.pycharm
      jetbrains.clion
      jre25_minimal

      # --- Audio ---
      ncpamixer

      # --- Browser extensions (native connectors) ---
      tridactyl-native
    ]
    ++ (with pkgs-unstable; [
      sfizz-ui
      zotero
    ]);

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

      Extensions = {
        Install = [
          "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/tridactyl-vim/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislikes/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi"
          "https://addons.mozilla.org/firefox/downloads/latest/besttimetracker/latest.xpi"
          "https://www.zotero.org/download/connector/dl?browser=firefox"
        ];
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
      id = 0;
      isDefault = true;

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
              {
                name = "Hydrogreen";
                url = "https://services.hydrogreen.pl";
              }
              {
                name = "Homelab";
                url = "http://192.168.1.134:5005/";
              }
              {
                name = "NixOS Packages";
                url = "https://search.nixos.org/packages?channel=unstable";
              }
              {
                name = "Home Manager Options";
                url = "https://home-manager-options.extranix.com/";
              }
            ];
          }
        ];
      };

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

        "browser.newtabpage.enabled" = true;
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

  home.activation.linkLibreWolfProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.librewolf" ]; then
      $DRY_RUN_CMD ln -s $VERBOSE_ARG "$HOME/.mozilla/firefox" "$HOME/.librewolf"
    fi
  '';
}
