{
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
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
    zotero

    openrgb-with-all-plugins

    mission-center
    qdirstat
    gnome-disk-utility
    file-roller
    xarchiver
    mousepad

    # --- Music ---
    ardour
    qpwgraph
    sfizz-ui

    # --- Media ---
    spotify
    vlc
    imv
    zathura

    # --- Development & tools ---
    hardinfo2
    jetbrains.pycharm
    jetbrains.clion
    jre25_minimal
    savvycan
    can-utils

    # --- Audio ---
    ncpamixer

    # --- Browser extensions (native connectors) ---
    tridactyl-native
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
      "application/x-zerosize" = [ "org.xfce.mousepad.desktop" ];
      "text/plain" = [ "org.xfce.mousepad.desktop" ];
      "text/markdown" = [ "org.xfce.mousepad.desktop" ];
      "text/x-typst" = [ "org.xfce.mousepad.desktop" ];
      "text/x-log" = [ "org.xfce.mousepad.desktop" ];
      "application/json" = [ "org.xfce.mousepad.desktop" ];
      "application/xml" = [ "org.xfce.mousepad.desktop" ];
      "application/x-typst" = [ "org.xfce.mousepad.desktop" ];
    };
  };

  # Thunar: right-click → copy full path (Wayland clipboard)
  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
      <action>
        <icon>edit-copy</icon>
        <name>_Kopiuj ścieżkę</name>
        <submenu></submenu>
        <unique-id>1749230000000000-1</unique-id>
        <command>wl-copy -- %f</command>
        <description>Skopiuj pełną ścieżkę do schowka</description>
        <range></range>
        <patterns>*</patterns>
        <directories/>
        <audio-files/>
        <image-files/>
        <other-files/>
        <text-files/>
        <video-files/>
      </action>
    </actions>
  '';

  xdg.configFile."tridactyl/tridactylrc".text = ''
    set newtab about:blank
  '';

  # --- Browser (LibreWolf) ---
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    profilesPath = ".mozilla/firefox";

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
      name = "default";
      path = "pin2b8jg.default";
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
        "browser.startup.page" = 3;
        "browser.sessionstore.privacy_level" = 0;
        "network.cookie.lifetimePolicy" = 0;

        "privacy.clearOnShutdown.cache" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.offlineApps" = false;
        "privacy.clearOnShutdown.siteSettings" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.clearOnShutdown_v2.cache" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
        "privacy.clearOnShutdown_v2.siteSettings" = false;
        "privacy.sanitize.pending" = "[]";
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
      return {
        font = wezterm.font 'FiraCode Nerd Font',
        font_size = 12.0,
        color_scheme = 'Catppuccin Mocha',
        window_background_opacity = 0.72,
        text_background_opacity = 0.0,
        enable_tab_bar = true,
        window_close_confirmation = 'NeverPrompt',
      }
    '';
  };

  # --- Code editor (VSCode) ---
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.userSettings = {
      "editor.fontFamily" = "'FiraCode Nerd Font', 'Symbols Nerd Font', monospace";
      "editor.fontLigatures" = true;
    };
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
