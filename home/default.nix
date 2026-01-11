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
    (lib.lowPrio pcloud) # Explicitly lower permissions
    zotero
    fastfetch
    zathura
    tridactyl-native
    xournalpp
    hardinfo2
    steam

    # # Media
    vlc
    flameshot
    zathura
    imv # image viewer

    # # Utils
    xclip
    tree
    bat
    eza
    duf
    gh
    ripgrep
    fd
    fzf
    btop
    unzip
    zip
    ncpamixer
    libqalculate
    libnotify

    yubioath-flutter
    yubikey-manager
  ];

  programs.rofi = {
    enable = true;
    #package = pkgs.rofi-wayland; # Crucial for Hyprland users

    # Optional: Styling to make it look modern
    # You can download custom .rasi themes later, this is a basic setup
    font = "JetBrainsMono Nerd Font 12";
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
    };

    # # Simple embedded theme (Dark Grey/Blue)
    # theme =
    #   #let
    #   #  inherit (config.lib.formats.rasi) mkLiteral;
    #   #in
    #   {
    #     "*" = {
    #       background-color = mkLiteral "#282c34";
    #       text-color = mkLiteral "#abb2bf";
    #       border-color = mkLiteral "#61afef";
    #     };
    #     "window" = {
    #       padding = mkLiteral "20px";
    #       border = mkLiteral "2px";
    #       border-radius = mkLiteral "10px";
    #     };
    #     "element" = {
    #       padding = mkLiteral "5px";
    #       border-radius = mkLiteral "5px";
    #     };
    #     "element selected" = {
    #       background-color = mkLiteral "#61afef";
    #       text-color = mkLiteral "#282c34";
    #     };
    #   };
  };

  # --- Shell ---
  programs.fish = {
    enable = true;

    functions = {
      n = {
        description = "support nnn quit and change directory";
        wraps = "nnn";
        body = ''
          # Block nesting of nnn in subshells
          if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
              echo "nnn is already running"
              return
          end

          # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
          if test -n "$XDG_CONFIG_HOME"
              set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
          else
              set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
          end

          # Run nnn with your specific flags:
          # -A (no auto-enter), -r (regex), -U (show user/group)
          command nnn $argv -A -r -U

          if test -e $NNN_TMPFILE
              source $NNN_TMPFILE
              rm $NNN_TMPFILE
          end
        '';
      };
    };

    shellInit = ''
      # Pager settings
      set -xg PAGER "bat --wrap=never --style=numbers,changes --theme gruvbox-dark"
      set -xg MANPAGER "sh -c 'col -bx | bat --language=man --style=numbers,rule'"
      set -xg MANROFFOPT "-c"
      set -xg MANWIDTH (math $COLUMNS - 6)

      # NNN settings
      set -xg NNN_FIFO '/tmp/nnn.fifo'
      set -xg NNN_PLUG 'o:fzopen;p:mocq;d:diffs;t:nmount;v:preview-tui;c:!convert "$nnn" png:- | xclip -sel clipboard -t image/png*'
      set -xg NNN_PAGER 'bat --wrap=never --style=changes'
      set -xg NNN_BATTHEME gruvbox-dark
    '';

    interactiveShellInit = ''
      # Vi Mode Enable
      fish_vi_key_bindings

      # Vi Cursor Styling
      set fish_cursor_default block blink
      set fish_cursor_insert line blink
      set fish_cursor_replace_one underscore blink
      set fish_cursor_visual block

      # FZF Bindings (requires fzf-fish plugin below)
      fzf_configure_bindings --git_status=\cs --git_log=\cg --history=\ch --variables=\cv --processes=\cp --directory=\cf

      # Pywal Colors (if the file exists)
      if test -e ~/.cache/wal/sequences
        cat ~/.cache/wal/sequences
      end
      if test -e ~/.cache/wal/colors-tty.sh
        bass source ~/.cache/wal/colors-tty.sh
      end

      # Greeting
      function fish_greeting
        # fortune | lolcat # Uncomment if you install fortune/lolcat
      end
    '';

    shellAliases = {
      dotfiles = "/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME";
      dot = "/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME";
      ll = "eza -ahl --no-user --time-style=long-iso --group-directories-first";
      path = "echo $PATH | tr -s ':' '\n'";
      fonts = "fc-list : family | sort";
    };

    shellAbbrs = {
      cat = "bat";
      grep = "rg";
      find = "fd";
      df = "duf";
      mixer = "ncpamixer";
      calc = "qalc";
      c = "qalc";
      vi = "hx";

      rebuild = "sudo nixos-rebuild switch --flake .#$hostname";
    };

    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "puffer";
        src = pkgs.fishPlugins.puffer.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }

    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { withNerdIcons = true; };

    plugins = {
      src =
        (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.9";
          sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
        })
        + "/plugins";
    };
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
      pull.rebase = false;
      user = {
        name = "ErgoAsh";
        email = "3192123+ErgoAsh@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "24.11";
}
