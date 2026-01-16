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
    flameshot
    grim
    slurp
    swappy
    wl-clipboard
    pavucontrol
    wdisplays

    ciscoPacketTracer8

    # # Media
    vlc
    flameshot
    zathura
    imv # image viewer

    # # Utils
    psmisc # killall cmd
    xclip
    ffmpeg
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
    blueman
    libqalculate
    libnotify
    nerd-fonts.fira-code

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

      windowrulev2 = [
        # Syntax: "workspace [ID], class:^(AppClassName)$"
        "workspace 1, title:(LibreWolf)"
        "workspace 2, class:^(rio)$"
        "workspace 4, class:^(obsidian)$"
        "workspace 5, class:^(vesktop)$" # Discord
      ];

      # -- Startup --
      exec-once = [
        "waybar"
        "swww init"
        "nm-applet --indicator"
        "dunst"
        "gammastep"
        "flameshot"
        "hyprctl setcursor Bibata-Modern-Ice 24"

        "[workspace 1 silent] LibreWolf"
        "[workspace 2 silent] rio"
        "[workspace 4 silent] obsidian"
        "[workspace 5 silent] vesktop"
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

      animations = {
        enabled = true;
        bezier = [ "linear, 0.0, 0.0, 1.0, 1.0" ];

        animation = [
          "workspaces, 1, 5, default, fade"
        ];
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
        "$modifier, D, exec, rofi -show drun"
        "$modifier, E, exec, nnn" # File manager
        "$modifier, B, exec, librewolf" # Browser
        "$modifier, L, exec, hyprlock"

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
        "$modifier CTRL, left, movecurrentworkspacetomonitor, l"
        "$modifier CTRL, right, movecurrentworkspacetomonitor, r"
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
        #", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"
        #", Print, exec, grim -g \"$(slurp)\" /tmp/screenshot.png && swappy -f /tmp/screenshot.png"
        ", Print, exec, XDG_CURRENT_DESKTOP=sway flameshot gui"
        #", Print, exec, flameshot gui"
      ];

      # Move/Resize windows with mouse
      bindm = [
        "$modifier, mouse:272, movewindow"
        "$modifier, mouse:273, resizewindow"
      ];
    };
  };

  # Configure night mode
  services.gammastep = {
    enable = true;
    provider = "manual"; # Or "geoclue2" for auto-location
    latitude = 51.246452;
    longitude = 22.568445;
    temperature = {
      day = 5700;
      night = 3500; # Warm!
    };
    settings = {
      general.adjustment-method = "wayland";
    };
  };

  # Optional: If you want to force specific mpris (media control) support
  services.mpris-proxy.enable = true;
  services.blueman-applet.enable = true;

  # 3. Configure Bar (Waybar)
  # Basic setup to get you started
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        fixed-center = false;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "bluetooth"
          "tray"
          "cpu"
          "memory"
          "custom/disk"
          "battery"
          "pulseaudio"
          "clock"
        ];

        tooltip = {
          enabled = true;
          interval = 50;
        };

        "hyprland/window" = {
          max-length = 75;
          separate-outputs = true;
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };

        "clock" = {
          # date (left) | time (middle) | icon (right)
          format = "{:%Y-%m-%d | %H:%M }";

          tooltip-format = "<span size='24pt'>{:%Y %B}</span>\n<tt><span size='16pt'>{calendar}</span></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
        };

        "cpu" = {
          interval = 5;
          format = "{usage}% "; # Value Left, Icon Right
          tooltip = true;
        };

        "memory" = {
          interval = 5;
          format = "{}% "; # Value Left, Icon Right
          tooltip-format = "RAM: {used:0.1f} GiB / {total:0.1f} GiB\nSwap: {swapUsed:0.1f} GiB / {swapTotal:0.1f} GiB";
        };

        "custom/disk" = {
          interval = 30;
          exec = "df -B1 / | awk 'NR==2 {printf \"%s (%.1f GiB / %.1f GiB)\", $5, $3/1073741824, $2/1073741824}'";
          format = "{} ";
          tooltip = true;
          tooltip-format = "Mount point: /";
        };

        "disk" = {
          interval = 30;
          format = "{percentage_used}% ({used} / {total}) "; # Value Left, Icon Right
          path = "/";
          tooltip-format = "{used} used out of {total} on {path}";
        };

        "bluetooth" = {
          format = "{icon}";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-connected = ""; # Solid icon when connected (or {icon})

          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon} ";
          format-muted = "🔇";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              "🔈"
              "🔉"
              "🔊"
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = [ "Easy Effects Sink" ];
        };

        "network" = {
          # Value Left, Icon Right
          format-ethernet = "{ipaddr} 󰈀";
          format-wifi = "{essid} ({signalStrength}%) {icon}";
          format-disconnected = "Disconnected 󰤮";

          tooltip-format = "{ifname} via {gwaddr}";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          on-click = "nm-connection-editor";
        };

        "battery" = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          # Shows: 80% (01:20) [Icon]
          format = "{capacity}% ({time}) {icon}";
          format-charging = "{capacity}% (Charging) {icon}";
          format-full = "{capacity}% {icon}";

          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip-format = "{timeTo}";
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "FiraCode Nerd Font", "Fira Code", sans-serif;
        min-height: 0;
      }

      window#waybar {
        background: rgba(43, 48, 59, 0.9);
        color: #ffffff;
      }

      #workspaces {
        margin: 0;
        padding: 0;
        background: transparent;
      }

      #workspaces button {
        /* Vertical padding 0, Horizontal 10px */
        padding: 0 10px;
        margin: 0;
        border-radius: 0;
        background-color: transparent;
        color: #ffffff;

        /* Crucial: Forces button to fill the bar's height */
        min-height: 30px;
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.2);
        box-shadow: none; /* remove any weird shadow lines */
      }

      #workspaces button.active {
        background-color: #64727d;
        /* Optional: A line at the bottom to show it's active */
        border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #disk,
      #custom-disk,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #bluetooth #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        padding: 0 15px 0 10px;
        margin: 0 4px;
        color: #ffffff;
        background-color: rgba(
          255,
          255,
          255,
          0.1
        ); /* Slight background to see bounds */
        border-radius: 5px;
      }

      #battery.charging,
      #battery.plugged {
        color: #ffffff;
        background-color: #26a65b;
      }

      #battery.critical:not(.charging) {
        background-color: #f53c3c;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #bluetooth {
        color: #7f849c; /* Grey (Disconnected) */
      }

      #bluetooth.connected {
        color: #89b4fa; /* Blue (Connected) */
      }

      #bluetooth.off,
      #bluetooth.disabled {
        color: #f38ba8; /* Red (Off/Disabled) */
      }
    '';
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "screenshot"; # Keep the blurred screenshot, or change to "/path/to/wallpaper.jpg"
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      # INPUT FIELD
      input-field = [
        {
          size = "250, 60";
          position = "0, -20";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "<i>Password...</i>";
          shadow_passes = 2;
        }
      ];

      # CLOCK LABEL
      label = [
        {
          text = "$TIME";
          color = "rgb(202, 211, 245)";
          font_size = 65;
          font_family = "JetBrains Mono";
          position = "0, 100"; # Move up
          halign = "center";
          valign = "center";
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # What to run when asked to lock
        before_sleep_cmd = "loginctl lock-session"; # Lock BEFORE suspend
        after_sleep_cmd = "hyprctl dispatch dpms on"; # Turn screen on when waking
      };

      listener = [
        {
          timeout = 150; # 2.5min
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330; # 5.5min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  services.flameshot = {
    # Also installs/enables flameshot
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        # Stops warnings for using Grim
        disabledGrimWarning = true;
      };
    };
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
      paths = "echo $PATH | tr -s ':' '\n'";
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
    options = [
      "--cmd cd"
    ];
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
      confirm-before-quit = false;
      window = {
        width = 900;
        height = 600;
        opacity = 0.5;
        blur = true;
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
