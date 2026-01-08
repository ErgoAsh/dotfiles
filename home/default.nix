{ pkgs, ... }:

{
  home.username = "ergoash";
  home.homeDirectory = "/home/ergoash";

  home.packages = with pkgs; [
    # Apps
    obsidian
    discord
    anki
    flameshot
    pcloud
    zotero
    fastfetch
    zathura
    tridactyl-native

    # Media
    vlc
    flameshot
    zathura
    imv

    # Utils
    gh
    ripgrep
    fd
    fzf
    btop
    unzip
    zip

    yubioath-flutter
    yubikey-manager
  ];

  # --- Shell ---
  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # --- Terminal ---
  programs.rio = {
    enable = true;
    settings = {
      window = {
        width = 900;
        height = 600;
      };
    };
  };

  # --- Editor ---
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = [
      pkgs.tinymist
      pkgs.typstyle
      pkgs.nixd
      pkgs.nixfmt-rfc-style
    ];

    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        mouse = true;
      };
    };

    languages = {
      language = [
        {
          name = "typst";
          auto-format = true;
          formatter = {
            command = "typstyle";
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
          };
          language-servers = [ "nixd" ];
        }
      ];

      language-server.nixd = {
        command = "nixd";
      };
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # --- Browser ---
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf; # Using LibreWolf instead of standard Firefox

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
    };

    profiles.ergoash = {
      isDefault = true;

      settings = {
        "browser.startup.homepage" = "https://google.com";
        "browser.search.region" = "PL";
        "browser.search.isUS" = false;

        "browser.startup.page" = 3; # Resume previous session
        "privacy.clearOnShutdown.sessions" = false;

        "network.cookie.lifetimePolicy" = 0;

        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.sanitize.sanitizeOnShutdown" = false;

        "media.eme.enabled" = true;
        "media.gmp-widevinecdm.visible" = true;
        "media.gmp-widevinecdm.enabled" = true;
      };
    };
  };

  # --- Git ---
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "${pkgs.gh}/bin/gh auth git-credential";

      user = {
        name = "ErgoAsh";
        email = "3192123+ErgoAsh@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "24.11";
}
