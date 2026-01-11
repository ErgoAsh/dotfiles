{ pkgs, ... }:

{
  home.username = "ergoash";
  home.homeDirectory = "/home/ergoash";

  home.packages = with pkgs; [
    # Apps
    obsidian
    vesktop
    anki
    (lib.lowPrio pcloud) # Explicitly lower permissions
    zotero
    fastfetch
    zathura
    tridactyl-native
    xournalpp
    hardinfo2
    steam
    #flameshot
    grim
    slurp
    swappy
    wl-clipboard

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

    # Hyprland
    waybar
    swww
    gammastep
    dunst
    networkmanagerapplet
    brightnessctl
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = [
      pkgs.hyprlandPlugins.hyprgrass
    ];

    # This imports your separate hyprland.conf file if you prefer it separate,
    # OR you can put the config right here in 'settings'.
    # Let's put it here for simplicity.
    settings = {

      # -- Startup --
      exec-once = [
        "waybar"
        "swww init"
        "nm-applet --indicator"
        "dunst"
        "gammastep"
      ];

      input = {
        kb_layout = "pl";
        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
          disable_while_typing = true;
        };

        touchdevice = {
          output = "eDP-1"; # Forces touch to internal laptop screen
          transform = 0;
        };
      };

      # -- Display --
      monitor = ",preferred,auto,1"; # Auto-detect resolution

      # -- General Look --
      general = {
        "$modifier" = "SUPER";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle"; # The fancy tiling mode
      };

      # -- Decorations --
      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2; # change to 1 if want to disable
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      gestures = {
        gesture = [ "3, horizontal, workspace" ];
        workspace_swipe_distance = 500;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_forever = true;
      };

      plugin = {
        touch_gestures = {
          # default sensitivity is 1.0
          sensitivity = 4.0;

          # must be >= 3
          workspace_swipe_fingers = 3;

          # switching workspaces by swiping from an edge
          workspace_swipe_edge = "d"; # 'd' = down (swipe up from bottom)

          # enable long-press to send right-click
          long_press_delay = 400;
        };
      };

      # -- KEYBINDINGS --
      bind = [
        # TODO clean

        # Apps
        "$modifier, Q, killactive,"
        "$modifier, RETURN, exec, rio"
        "$modifier, SPACE, exec, rofi -show drun"
        "$modifier, E, exec, nnn" # File manager
        "$modifier, B, exec, librewolf" # Browser

        # Windows
        "$modifier, V, togglefloating,"
        "$modifier, F, fullscreen,"

        # Focus
        "$modifier, left, movefocus, l"
        "$modifier, right, movefocus, r"
        "$modifier, up, movefocus, u"
        "$modifier, down, movefocus, d"

        # ============= WORKSPACE OVERVIEW =============
        "$modifier CTRL, D, exec, dock"
        "$modifier, TAB, exec, qs ipc -c overview call overview toggle"

        # ============= TERMINALS =============
        # "$modifier, Return, exec, ${terminal}"

        # ============= APPLICATION LAUNCHERS =============
        "$modifier, K, exec, qs-keybinds"
        "$modifier CTRL, C, exec, qs-cheatsheets"
        "$modifier SHIFT, K, exec, list-keybinds"
        "$modifier SHIFT, D, exec, discord"
        "$modifier ALT, W, exec, web-search"
        "$modifier SHIFT, W, exec, qs-wallpapers-apply"
        "$modifier SHIFT, N, exec, swaync-client -rs"
        # "$modifier, W, exec, ${browser}"
        "$modifier, Y, exec, rio -e yazi"
        "$modifier, E, exec, emopicker9000"
        "$modifier, S, exec, screenshootin"

        # ============= SCREENSHOTS =============
        "$modifier CTRL, S, exec, hyprshot -m output -o $HOME/Pictures/ScreenShots"
        "$modifier SHIFT, S, exec, hyprshot -m window -o $HOME/Pictures/ScreenShots"
        "$modifier ALT, S, exec, hyprshot -m region -o $HOME/Pictures/ScreenShots"
        "$modifier, O, exec, obs"
        "$modifier ALT, C, exec, hyprpicker -a"
        "$modifier, G, exec, gimp"
        "$modifier SHIFT, T, exec, pypr toggle term"
        "$modifier, T, exec, thunar"
        "$modifier ALT, M, exec, ncpamixer"

        # ============= WINDOW MANAGEMENT =============
        "$modifier, Q, killactive,"
        "$modifier, P, pseudo,"
        "$modifier SHIFT, I, togglesplit,"
        "$modifier, F, fullscreen,"
        "$modifier SHIFT, F, togglefloating,"
        "$modifier ALT, F, workspaceopt, allfloat"
        "$modifier SHIFT, C, exit,"

        # ============= WINDOW MOVEMENT (ARROW KEYS) =============
        "$modifier SHIFT, left, movewindow, l"
        "$modifier SHIFT, right, movewindow, r"
        "$modifier SHIFT, up, movewindow, u"
        "$modifier SHIFT, down, movewindow, d"

        # ============= WINDOW MOVEMENT (VI STYLE) =============
        "$modifier SHIFT, h, movewindow, l"
        "$modifier SHIFT, l, movewindow, r"
        "$modifier SHIFT, k, movewindow, u"
        "$modifier SHIFT, j, movewindow, d"

        # ============= WINDOW SWAPPING (ARROW KEYS) =============
        "$modifier ALT, left, swapwindow, l"
        "$modifier ALT, right, swapwindow, r"
        "$modifier ALT, up, swapwindow, u"
        "$modifier ALT, down, swapwindow, d"

        # ============= WINDOW SWAPPING (VI KEYCODES) =============
        "$modifier ALT, 43, swapwindow, l"
        "$modifier ALT, 46, swapwindow, r"
        "$modifier ALT, 45, swapwindow, u"
        "$modifier ALT, 44, swapwindow, d"

        # ============= FOCUS MOVEMENT (ARROW KEYS) =============
        "$modifier, left, movefocus, l"
        "$modifier, right, movefocus, r"
        "$modifier, up, movefocus, u"
        "$modifier, down, movefocus, d"

        # ============= FOCUS MOVEMENT (VI STYLE) =============
        "$modifier, h, movefocus, l"
        "$modifier, l, movefocus, r"
        "$modifier, k, movefocus, u"
        "$modifier, j, movefocus, d"

        # ============= WORKSPACE SWITCHING (1-10) =============
        "$modifier, 1, workspace, 1"
        "$modifier, 2, workspace, 2"
        "$modifier, 3, workspace, 3"
        "$modifier, 4, workspace, 4"
        "$modifier, 5, workspace, 5"
        "$modifier, 6, workspace, 6"
        "$modifier, 7, workspace, 7"
        "$modifier, 8, workspace, 8"
        "$modifier, 9, workspace, 9"
        "$modifier, 0, workspace, 10"

        # ============= MOVE WINDOW TO WORKSPACE (1-10) =============
        "$modifier SHIFT, SPACE, movetoworkspace, special"
        "$modifier, SPACE, togglespecialworkspace"
        "$modifier SHIFT, 1, movetoworkspace, 1"
        "$modifier SHIFT, 2, movetoworkspace, 2"
        "$modifier SHIFT, 3, movetoworkspace, 3"
        "$modifier SHIFT, 4, movetoworkspace, 4"
        "$modifier SHIFT, 5, movetoworkspace, 5"
        "$modifier SHIFT, 6, movetoworkspace, 6"
        "$modifier SHIFT, 7, movetoworkspace, 7"
        "$modifier SHIFT, 8, movetoworkspace, 8"
        "$modifier SHIFT, 9, movetoworkspace, 9"
        "$modifier SHIFT, 0, movetoworkspace, 10"

        # ============= WORKSPACE NAVIGATION =============
        "$modifier CONTROL, right, workspace, e+1"
        "$modifier CONTROL, left, workspace, e-1"
        "$modifier, mouse_down, workspace, e+1"
        "$modifier, mouse_up, workspace, e-1"

        # ============= WINDOW CYCLING =============
        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"

        # ============= MEDIA & HARDWARE CONTROLS =============
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"

        # Screenshots (Simulating Flameshot behavior)
        # Shift+PrintScreen -> Select area -> Opens Swappy editor
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
      ];

      # Move/Resize windows with mouse
      bindm = [
        "$modifier, mouse:272, movewindow"
        "$modifier, mouse:273, resizewindow"
      ];
    };
  };

  # 2. Configure Night Mode (Gammastep)
  services.gammastep = {
    enable = true;
    provider = "manual"; # Or "geoclue2" for auto-location
    latitude = 52.2; # Example (Warsaw), change to yours!
    longitude = 21.0;
    temperature = {
      day = 5700;
      night = 3500; # Warm!
    };
    settings = {
      general.adjustment-method = "wayland";
    };
  };

  # 3. Configure Bar (Waybar)
  # Basic setup to get you started
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "network"
          "cpu"
          "memory"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        "battery" = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
      };
    };
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background-color: rgba(43, 48, 59, 0.9);
        color: #ffffff;
      }
    '';
  };

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
