{ ... }: {

  flake.modules.homeManager.librewolf =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
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

      home.activation.linkLibreWolfProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -e "$HOME/.librewolf" ]; then
          $DRY_RUN_CMD ln -s $VERBOSE_ARG "$HOME/.mozilla/firefox" "$HOME/.librewolf"
        fi
      '';

    };
}
